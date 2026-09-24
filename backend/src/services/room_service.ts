import type { Socket } from 'socket.io';

import {
  PLAYER_SYMBOL,
  Room,
  ROOM_STATUS,
} from '../models/room_model';

import type {
  IPlayer,
  PlayerSymbol,
  RoomTheme,
} from '../models/room_model';

import Logger from '../core/utils/logger';

interface CreateRoomParams {
  playerName: string;
  symbol: PlayerSymbol;
  theme: RoomTheme;
  socket: Socket;
}

interface JoinRoomParams {
  playerName: string;
  roomCode: string;
  socket: Socket;
}

interface MakeMoveParams {
  roomCode: string;
  index: number;
  socket: Socket;
}

interface SubmitGameResultParams {
  roomCode: string;
  winnerSocketId: string;
  winningIndexes: number[];
  socket: Socket;
}

interface SetPlayerReadyParams {
  roomCode: string;
  isReady: boolean;
  socket: Socket;
}

interface GameResult {
  room: InstanceType<typeof Room>;
  winnerSocketId: string;
  winningIndexes: number[];
  completedRound: number;
  gameFinished: boolean;
}

interface MoveResult {
  room: InstanceType<typeof Room>;
  move: {
    index: number;
    symbol: PlayerSymbol;
  };
}

class RoomService {
  async createRoom({
    playerName,
    symbol,
    theme,
    socket,
  }: CreateRoomParams): Promise<
    InstanceType<typeof Room>
  > {
    try {
      const roomCode =
        await this._generateUniqueRoomCode();

      const player: IPlayer = {
        name: playerName,
        symbol,
        socketId: socket.id,
        points: 0,
        isReady: true,
      };

      const room = await Room.create({
        code: roomCode,
        theme,
        players: [player],
        occupancy: 1,
        currentRound: 0,
        roundStatus: ROOM_STATUS.WAITING,
        turn: player,
        turnIndex: 0,
      });

      socket.join(room.code);

      return room;
    } catch (error: unknown) {
      Logger.error('Failed to create room', error);
      throw error;
    }
  }

  async joinRoom({
    playerName,
    roomCode,
    socket,
  }: JoinRoomParams): Promise<
    InstanceType<typeof Room>
  > {
    try {
      const code = roomCode
        .trim()
        .toUpperCase();

      const room = await this.getRoom(code);

      if (!room) {
        throw new Error('Room not found');
      }

      if (
        room.roundStatus === ROOM_STATUS.PLAYING
      ) {
        throw new Error(
          'Game is already in progress',
        );
      }

      if (room.players.length >= 2) {
        throw new Error('Room is full');
      }

      const hostPlayer = room.players[0];

      if (!hostPlayer) {
        throw new Error(
          'Room does not have a host player',
        );
      }

      const guestSymbol =
        hostPlayer.symbol === PLAYER_SYMBOL.X
          ? PLAYER_SYMBOL.O
          : PLAYER_SYMBOL.X;

      room.players.push({
        name: playerName,
        symbol: guestSymbol,
        socketId: socket.id,
        points: 0,
        isReady: true,

      });

      room.occupancy = room.players.length;

      // Joining the room does NOT start the round.
      room.roundStatus = ROOM_STATUS.PLAYING;
      room.currentRound = 1;

      await room.save();

      socket.join(room.code);

      return room;
    } catch (error: unknown) {
      Logger.error('Failed to join room', error);
      throw error;
    }
  }

  async makeMove({
    roomCode,
    index,
    socket,
  }: MakeMoveParams): Promise<MoveResult> {
    try {
      const code = roomCode
        .trim()
        .toUpperCase();

      const room = await this.getRoom(code);

      if (!room) {
        throw new Error('Room not found');
      }

      if (
        room.roundStatus !== ROOM_STATUS.PLAYING
      ) {
        throw new Error('Round is not active');
      }

      if (
        !Number.isInteger(index) ||
        index < 0 ||
        index >= room.boardSize
      ) {
        throw new Error(
          'Invalid board position',
        );
      }

      const playerIndex =
        room.players.findIndex(
          (player) =>
            player.socketId === socket.id,
        );

      if (playerIndex === -1) {
        throw new Error(
          'Player is not part of this room',
        );
      }

      if (room.turnIndex !== playerIndex) {
        throw new Error('Not your turn');
      }

      const player = room.players[playerIndex];

      if (!player) {
        throw new Error('Player not found');
      }

      const move = {
        index,
        symbol: player.symbol,
      };

      room.turnIndex =
        room.turnIndex === 0 ? 1 : 0;

      room.turn =
        room.players[room.turnIndex] ?? null;

      await room.save();

      return {
        room,
        move,
      };
    } catch (error: unknown) {
      Logger.error('Failed to make move', error);
      throw error;
    }
  }

  async submitGameResult({
    roomCode,
    winnerSocketId,
    winningIndexes,
    socket,
  }: SubmitGameResultParams): Promise<GameResult> {
    try {
      const code = roomCode
        .trim()
        .toUpperCase();

      const room = await this.getRoom(code);

      if (!room) {
        throw new Error('Room not found');
      }

      if (
        room.roundStatus !== ROOM_STATUS.PLAYING
      ) {
        throw new Error('Round is not active');
      }

      if (room.players.length !== 2) {
        throw new Error(
          'Room does not have two players',
        );
      }

      if (socket.id !== winnerSocketId) {
        throw new Error('Invalid winner');
      }

      const winnerIndex =
        room.players.findIndex(
          (player) =>
            player.socketId === winnerSocketId,
        );

      if (winnerIndex === -1) {
        throw new Error(
          'Winner is not part of this room',
        );
      }

      if (!Array.isArray(winningIndexes)) {
        throw new Error(
          'Invalid winning indexes',
        );
      }

      const winner = room.players[winnerIndex];

      if (!winner) {
        throw new Error('Winner not found');
      }

      // Round has finished.
      room.roundStatus = ROOM_STATUS.RESULT;

      // Players must ready up before the next round.
      room.players.forEach((player) => {
        player.isReady = false;
      });

      // Award one point.
      winner.points = (winner.points ?? 0) + 1;

      const completedRound =
        room.currentRound;

      const gameFinished =
        completedRound >= room.maxRounds;

      await room.save();

      return {
        room,
        winnerSocketId,
        winningIndexes,
        completedRound,
        gameFinished,
      };
    } catch (error: unknown) {
      Logger.error(
        'Failed to submit game result',
        error,
      );
      throw error;
    }
  }

  async setPlayerReady({
    roomCode,
    isReady,
    socket,
  }: SetPlayerReadyParams): Promise<
    InstanceType<typeof Room>
  > {
    if (typeof isReady !== 'boolean') {
      throw new Error(
        'isReady must be a boolean',
      );
    }

    const code = roomCode
      .trim()
      .toUpperCase();

    const room = await this.getRoom(code);

    if (!room) {
      throw new Error('Room not found');
    }

    if (room.players.length !== 2) {
      throw new Error(
        'Room does not have two players',
      );
    }

    const player = room.players.find(
      (player) =>
        player.socketId === socket.id,
    );

    if (!player) {
      throw new Error(
        'Player is not in this room',
      );
    }

    if (
      room.roundStatus === ROOM_STATUS.PLAYING
    ) {
      throw new Error(
        'Round is already active',
      );
    }

    if (
      room.currentRound >= room.maxRounds &&
      room.roundStatus === ROOM_STATUS.RESULT
    ) {
      throw new Error('Game has finished');
    }

    // Update this player's ready state.
    player.isReady = isReady;

    const allReady = room.players.every(
      (player) => player.isReady,
    );

    if (allReady) {
      // Start the next round.
      room.currentRound += 1;

      room.turnIndex = 0;

      room.turn =
        room.players[room.turnIndex] ?? null;

      room.roundStatus =
        ROOM_STATUS.PLAYING;

      // Ready state is only used as a gate
      // for starting the round.
      room.players.forEach((player) => {
        player.isReady = false;
      });
    }

    await room.save();

    return room;
  }

  async getRoom(
    roomCode: string,
  ): Promise<
    InstanceType<typeof Room> | null
  > {
    try {
      return await Room.findOne({
        code: roomCode
          .trim()
          .toUpperCase(),
      });
    } catch (error: unknown) {
      Logger.error('Failed to get room', error);
      throw error;
    }
  }

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

        const existingRoom =
          await Room.exists({ code });

        if (!existingRoom) {
          return code;
        }
      }

      throw new Error(
        'Unable to generate a unique room code. Please try again.',
      );
    } catch (error: unknown) {
      Logger.error(
        'Failed to generate unique room code',
        error,
      );
      throw error;
    }
  }

  private _generateRoomCode(): string {
    const characters =
      'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    let code = '';

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