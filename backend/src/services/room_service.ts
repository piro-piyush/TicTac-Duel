import {
  and,
  eq,
  sql,
} from "drizzle-orm";

import Logger from "../core/utils/logger.js";
import { db } from "../db/index.js";
import type {
  PlayerSymbol,
  RoomTheme,
} from "../db/schema.js";
import {
  players,
  roomPlayers,
  rooms,
} from "../db/schema.js";
import type {
  NewRoom,
} from "../db/types.js";

// -----------------------------------------------------------------------------
// Types
// -----------------------------------------------------------------------------

interface CreateRoomParams {
  playerId: string;
  playerName: string;
  symbol: PlayerSymbol;
  theme: RoomTheme;
  maxRounds: number;
  isPrivate: boolean;
}

interface JoinRoomParams {
  playerId: string;
  playerName: string;
  roomCode: string;
}

interface MakeMoveParams {
  roomCode: string;
  index: number;
  playerId: string;
}

interface SubmitGameResultParams {
  roomCode: string;
  winnerPlayerId: string | null;
  winningIndexes: number[];
  playerId: string;
}

interface SetPlayerReadyParams {
  roomCode: string;
  isReady: boolean;
  playerId: string;
}

interface RoomPlayer {
  id: string;
  name: string;
  symbol: PlayerSymbol;
  points: number;
  isReady: boolean;
}

interface Room {
  id: string;
  code: string;
  hostPlayerId: string;
  theme: RoomTheme;
  maxRounds: number;
  currentRound: number;
  roundStatus: string;
  turnPlayerId: string | null;
  turnIndex: number;
  boardSize: number;
  players: RoomPlayer[];
  occupancy: number;
  createdAt: Date;
  updatedAt: Date;
}

interface MoveResult {
  room: Room;
  move: {
    index: number;
    symbol: PlayerSymbol;
  };
}

interface GameResult {
  room: Room;
  winnerPlayerId: string | null;
  winningIndexes: number[];
  completedRound: number;
  gameFinished: boolean;
}

// -----------------------------------------------------------------------------
// Room Service
// -----------------------------------------------------------------------------

class RoomService {
  // ---------------------------------------------------------------------------
  // Create Room
  // ---------------------------------------------------------------------------

  async createRoom({
    playerId,
    playerName,
    symbol,
    theme,
    maxRounds,
    isPrivate,
  }: CreateRoomParams): Promise<Room> {
    try {
      const roomCode =
        await this._generateUniqueRoomCode();

      const newRoom: NewRoom = {
        code: roomCode,
        hostPlayerId: playerId,
        theme,
        maxRounds,
        isPrivate,
        currentRound: 0,
        roundStatus: "waiting",
        turnPlayerId: playerId,
        turnIndex: 0,
        boardSize: 9,
      };

      return await db.transaction(async (tx) => {
        await tx
          .insert(players)
          .values({
            id: playerId,
          })
          .onConflictDoNothing({
            target: players.id,
          });

        const [room] = await tx
          .insert(rooms)
          .values(newRoom)
          .returning();

        if (!room) {
          throw new Error("Failed to create room");
        }

        await tx
          .insert(roomPlayers)
          .values({
            roomId: room.id,
            playerId,
            name: playerName.trim(),
            symbol,
            points: 0,
            isReady: false,
          });

        return this._getRoomById(room.id, tx);
      });
    } catch (error: unknown) {
      Logger.error(
        "Failed to create room",
        error,
      );

      throw error;
    }
  }

  // ---------------------------------------------------------------------------
  // Join Room
  // ---------------------------------------------------------------------------

  async joinRoom({
    playerId,
    playerName,
    roomCode,
  }: JoinRoomParams): Promise<Room> {
    try {
      const code =
        this._normalizeRoomCode(roomCode);

      const room = await this.getRoom(code);

      if (!room) {
        throw new Error("Room not found");
      }

      if (room.roundStatus === "playing") {
        throw new Error(
          "Game is already in progress",
        );
      }

      if (room.players.length >= 2) {
        throw new Error("Room is full");
      }

      const existingPlayer = room.players.find(
        (player) => player.id === playerId,
      );

      if (existingPlayer) {
        throw new Error(
          "Player is already in this room",
        );
      }

      const hostPlayer = room.players[0];

      if (!hostPlayer) {
        throw new Error(
          "Room has no host player",
        );
      }

      const guestSymbol =
        hostPlayer.symbol === "x"
          ? "o"
          : "x";

      return await db.transaction(async (tx) => {
        await tx
          .insert(players)
          .values({
            id: playerId,
          })
          .onConflictDoNothing({
            target: players.id,
          });

        await tx
          .insert(roomPlayers)
          .values({
            roomId: room.id,
            playerId,
            name: playerName.trim(),
            symbol: guestSymbol,
            points: 0,
            isReady: false,
          });

        return this._getRoomById(room.id, tx);
      });
    } catch (error: unknown) {
      Logger.error(
        "Failed to join room",
        error,
      );

      throw error;
    }
  }

  // ---------------------------------------------------------------------------
  // Make Move
  // ---------------------------------------------------------------------------

  async makeMove({
    roomCode,
    index,
    playerId,
  }: MakeMoveParams): Promise<MoveResult> {
    try {
      const code =
        this._normalizeRoomCode(roomCode);

      const room = await this.getRoom(code);

      if (!room) {
        throw new Error("Room not found");
      }

      if (room.roundStatus !== "playing") {
        throw new Error("Round is not active");
      }

      if (
        !Number.isInteger(index) ||
        index < 0 ||
        index >= room.boardSize
      ) {
        throw new Error(
          "Invalid board position",
        );
      }

      const player = room.players.find(
        (roomPlayer) =>
          roomPlayer.id === playerId,
      );

      if (!player) {
        throw new Error(
          "Player is not part of this room",
        );
      }

      if (room.turnPlayerId !== player.id) {
        throw new Error("Not your turn");
      }

      const nextTurnIndex =
        room.turnIndex === 0 ? 1 : 0;

      const nextPlayer =
        room.players[nextTurnIndex];

      if (!nextPlayer) {
        throw new Error(
          "Unable to determine next player",
        );
      }

      await db
        .update(rooms)
        .set({
          turnIndex: nextTurnIndex,
          turnPlayerId: nextPlayer.id,
          updatedAt: new Date(),
        })
        .where(eq(rooms.id, room.id));

      const updatedRoom =
        await this.getRoom(code);

      if (!updatedRoom) {
        throw new Error(
          "Failed to retrieve updated room",
        );
      }

      return {
        room: updatedRoom,
        move: {
          index,
          symbol: player.symbol,
        },
      };
    } catch (error: unknown) {
      Logger.error(
        "Failed to make move",
        error,
      );

      throw error;
    }
  }

  // ---------------------------------------------------------------------------
  // Submit Game Result
  // ---------------------------------------------------------------------------

  async submitGameResult({
    roomCode,
    winnerPlayerId,
    winningIndexes,
    playerId,
  }: SubmitGameResultParams): Promise<GameResult> {
    try {
      const code =
        this._normalizeRoomCode(roomCode);

      const room = await this.getRoom(code);

      if (!room) {
        throw new Error("Room not found");
      }

      if (room.roundStatus !== "playing") {
        throw new Error("Round is not active");
      }

      if (room.players.length !== 2) {
        throw new Error(
          "Room does not have two players",
        );
      }

      if (!Array.isArray(winningIndexes)) {
        throw new Error(
          "Invalid winning indexes",
        );
      }

      const submittingPlayer =
        room.players.find(
          (player) => player.id === playerId,
        );

      if (!submittingPlayer) {
        throw new Error(
          "Player is not in this room",
        );
      }

      // -----------------------------------------------------------------------
      // Draw
      // -----------------------------------------------------------------------

      if (winnerPlayerId === null) {
        await db
          .update(roomPlayers)
          .set({
            isReady: false,
          })
          .where(
            eq(
              roomPlayers.roomId,
              room.id,
            ),
          );

        await db
          .update(rooms)
          .set({
            roundStatus: "result",
            turnPlayerId: null,
            updatedAt: new Date(),
          })
          .where(eq(rooms.id, room.id));

        const completedRound =
          room.currentRound;

        const gameFinished =
          completedRound >= room.maxRounds;

        const updatedRoom =
          await this.getRoom(code);

        if (!updatedRoom) {
          throw new Error(
            "Failed to retrieve updated room",
          );
        }

        return {
          room: updatedRoom,
          winnerPlayerId: null,
          winningIndexes: [],
          completedRound,
          gameFinished,
        };
      }

      // -----------------------------------------------------------------------
      // Win
      // -----------------------------------------------------------------------

      if (
        submittingPlayer.id !== winnerPlayerId
      ) {
        throw new Error("Invalid winner");
      }

      const winner = room.players.find(
        (player) =>
          player.id === winnerPlayerId,
      );

      if (!winner) {
        throw new Error(
          "Winner is not part of this room",
        );
      }

      const winnerIndex =
        room.players.findIndex(
          (player) =>
            player.id === winnerPlayerId,
        );

      if (winnerIndex === -1) {
        throw new Error(
          "Winner not found",
        );
      }

      await db.transaction(async (tx) => {
        await tx
          .update(roomPlayers)
          .set({
            points: sql`${roomPlayers.points} + 1`,
            isReady: false,
          })
          .where(
            eq(
              roomPlayers.id,
              winner.id,
            ),
          );

        await tx
          .update(roomPlayers)
          .set({
            isReady: false,
          })
          .where(
            eq(
              roomPlayers.roomId,
              room.id,
            ),
          );

        await tx
          .update(rooms)
          .set({
            roundStatus: "result",
            turnIndex: winnerIndex,
            turnPlayerId: winnerPlayerId,
            updatedAt: new Date(),
          })
          .where(eq(rooms.id, room.id));
      });

      const completedRound =
        room.currentRound;

      const gameFinished =
        completedRound >= room.maxRounds;

      const updatedRoom =
        await this.getRoom(code);

      if (!updatedRoom) {
        throw new Error(
          "Failed to retrieve updated room",
        );
      }

      return {
        room: updatedRoom,
        winnerPlayerId,
        winningIndexes,
        completedRound,
        gameFinished,
      };
    } catch (error: unknown) {
      Logger.error(
        "Failed to submit game result",
        error,
      );

      throw error;
    }
  }

  // ---------------------------------------------------------------------------
  // Set Player Ready
  // ---------------------------------------------------------------------------

  async setPlayerReady({
    roomCode,
    isReady,
    playerId,
  }: SetPlayerReadyParams): Promise<Room> {
    try {
      if (typeof isReady !== "boolean") {
        throw new Error(
          "isReady must be a boolean",
        );
      }

      const code =
        this._normalizeRoomCode(roomCode);

      const room = await this.getRoom(code);

      if (!room) {
        throw new Error("Room not found");
      }

      const player = room.players.find(
        (roomPlayer) =>
          roomPlayer.id === playerId,
      );

      if (!player) {
        throw new Error(
          "Player is not in this room",
        );
      }

      if (room.roundStatus === "playing") {
        throw new Error(
          "Round is already active",
        );
      }

      if (
        room.currentRound >= room.maxRounds &&
        room.roundStatus === "result"
      ) {
        throw new Error(
          "Game has finished",
        );
      }

      await db
        .update(roomPlayers)
        .set({
          isReady,
        })
        .where(
          and(
            eq(
              roomPlayers.roomId,
              room.id,
            ),
            eq(
              roomPlayers.playerId,
              player.id,
            ),
          ),
        );

      const updatedRoom =
        await this.getRoom(code);

      if (!updatedRoom) {
        throw new Error(
          "Failed to retrieve updated room",
        );
      }

      const hasAllPlayers =
        updatedRoom.players.length === 2;

      const allReady =
        hasAllPlayers &&
        updatedRoom.players.every(
          (roomPlayer) =>
            roomPlayer.isReady,
        );

      if (allReady) {
        const currentTurnIndex =
          updatedRoom.turnIndex;

        const startingPlayer =
          updatedRoom.players[
          currentTurnIndex
          ];

        if (!startingPlayer) {
          throw new Error(
            "Unable to determine starting player",
          );
        }

        await db.transaction(async (tx) => {
          await tx
            .update(rooms)
            .set({
              currentRound:
                updatedRoom.currentRound + 1,
              roundStatus: "playing",
              turnPlayerId:
                startingPlayer.id,
              updatedAt: new Date(),
            })
            .where(
              eq(
                rooms.id,
                updatedRoom.id,
              ),
            );

          await tx
            .update(roomPlayers)
            .set({
              isReady: false,
            })
            .where(
              eq(
                roomPlayers.roomId,
                updatedRoom.id,
              ),
            );
        });
      }

      const finalRoom =
        await this.getRoom(code);

      if (!finalRoom) {
        throw new Error(
          "Failed to retrieve final room state",
        );
      }

      return finalRoom;
    } catch (error: unknown) {
      Logger.error(
        "Failed to update player ready status",
        error,
      );

      throw error;
    }
  }

  // ---------------------------------------------------------------------------
  // Get Room By Code
  // ---------------------------------------------------------------------------

  async getRoom(
    roomCode: string,
  ): Promise<Room | null> {
    try {
      const code =
        this._normalizeRoomCode(roomCode);

      return await this._getRoomByCode(
        code,
        db,
      );
    } catch (error: unknown) {
      Logger.error(
        "Failed to get room",
        error,
      );

      throw error;
    }
  }

  // ---------------------------------------------------------------------------
  // Get Room By ID
  // ---------------------------------------------------------------------------

  async getRoomById(
    roomId: string,
  ): Promise<Room | null> {
    return this._getRoomById(
      roomId,
      db,
    );
  }

  // ---------------------------------------------------------------------------
  // Get Rooms
  // ---------------------------------------------------------------------------

  async getRooms() {
    const roomRows = await db
      .select()
      .from(rooms);

    return roomRows;
  }

  // ---------------------------------------------------------------------------
  // Delete Room
  // ---------------------------------------------------------------------------

  async deleteRoom(id: string) {
    const [room] = await db
      .delete(rooms)
      .where(eq(rooms.id, id.trim()))
      .returning();

    return room ?? null;
  }

  // ---------------------------------------------------------------------------
  // Private: Get Room By Code
  // ---------------------------------------------------------------------------

  private async _getRoomByCode(
    code: string,
    database: typeof db,
  ): Promise<Room | null> {
    const result = await database
      .select({
        room: rooms,
        roomPlayer: roomPlayers,
      })
      .from(rooms)
      .leftJoin(
        roomPlayers,
        eq(
          roomPlayers.roomId,
          rooms.id,
        ),
      )
      .where(eq(rooms.code, code));

    if (result.length === 0) {
      return null;
    }

    const first = result[0];

    if (!first) {
      return null;
    }

    return this._mapRoom(
      first.room,
      result
        .map((row) => row.roomPlayer)
        .filter(
          (
            player,
          ): player is NonNullable<
            typeof player
          > => player !== null,
        ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private: Get Room By ID
  // ---------------------------------------------------------------------------

  private async _getRoomById(
    roomId: string,
    database: Pick<typeof db, "select">,
  ): Promise<Room> {
    const result = await database
      .select({
        room: rooms,
        roomPlayer: roomPlayers,
      })
      .from(rooms)
      .leftJoin(
        roomPlayers,
        eq(
          roomPlayers.roomId,
          rooms.id,
        ),
      )
      .where(eq(rooms.id, roomId));

    if (result.length === 0) {
      throw new Error("Room not found");
    }

    const first = result[0];

    if (!first) {
      throw new Error("Room not found");
    }

    return this._mapRoom(
      first.room,
      result
        .map((row) => row.roomPlayer)
        .filter(
          (
            player,
          ): player is NonNullable<
            typeof player
          > => player !== null,
        ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private: Map Database Result
  // ---------------------------------------------------------------------------

  private _mapRoom(
    room: typeof rooms.$inferSelect,
    roomPlayerRows: Array<
      typeof roomPlayers.$inferSelect
    >,
  ): Room {
    const mappedPlayers: RoomPlayer[] =
      roomPlayerRows.map((player) => ({
        id: player.playerId,
        name: player.name,
        symbol:
          player.symbol as PlayerSymbol,
        points: player.points,
        isReady: player.isReady,
      }));

    return {
      id: room.id,
      code: room.code,
      hostPlayerId: room.hostPlayerId,
      theme: room.theme as RoomTheme,
      maxRounds: room.maxRounds,
      currentRound: room.currentRound,
      roundStatus: room.roundStatus,
      turnPlayerId: room.turnPlayerId,
      turnIndex: room.turnIndex,
      boardSize: room.boardSize,
      players: mappedPlayers,
      occupancy: mappedPlayers.length,
      createdAt: room.createdAt,
      updatedAt: room.updatedAt,
    };
  }

  // ---------------------------------------------------------------------------
  // Private: Normalize Room Code
  // ---------------------------------------------------------------------------

  private _normalizeRoomCode(
    roomCode: string,
  ): string {
    return roomCode
      .trim()
      .toUpperCase();
  }

  // ---------------------------------------------------------------------------
  // Private: Generate Unique Room Code
  // ---------------------------------------------------------------------------

  private async _generateUniqueRoomCode(): Promise<string> {
    try {
      const maxAttempts = 10;

      for (
        let attempt = 1;
        attempt <= maxAttempts;
        attempt++
      ) {
        const code =
          this._generateRoomCode();

        const existingRoom = await db
          .select({
            id: rooms.id,
          })
          .from(rooms)
          .where(eq(rooms.code, code))
          .limit(1);

        if (existingRoom.length === 0) {
          return code;
        }
      }

      throw new Error(
        "Unable to generate a unique room code. Please try again.",
      );
    } catch (error: unknown) {
      Logger.error(
        "Failed to generate unique room code",
        error,
      );

      throw error;
    }
  }

  // ---------------------------------------------------------------------------
  // Private: Generate Room Code
  // ---------------------------------------------------------------------------

  private _generateRoomCode(): string {
    const characters =
      "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

    let code = "";

    for (let i = 0; i < 6; i++) {
      const index = Math.floor(
        Math.random() * characters.length,
      );

      code += characters[index];
    }

    return code;
  }
}

export default new RoomService();