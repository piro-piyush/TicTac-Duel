const Room = require('../models/room_model');
const Logger = require('../core/utils/logger');

class RoomService {
  async createRoom({
    playerName,
    symbol,
    theme,
    socket,
  }) {
    try {
      const roomCode = await this._generateUniqueRoomCode();

      const player = {
        name: playerName,
        symbol,
        socketId: socket.id,
      };

      const room = await Room.create({
        code: roomCode,
        theme,
        players: [
          player,
        ],
        isPlaying: false,
        turn: player,
        turnIndex: 0,
      });

      // Join Socket.IO room.
      socket.join(room.code);

      return room;
    } catch (error) {

      throw error;
    }
  }

  async joinRoom({
    playerName,
    roomCode,
    socket,
  }) {
    try {
      const code = roomCode.trim().toUpperCase();

      const room = await Room.findOne({
        code,
      });

      if (!room) {
        throw new Error('Room not found');
      }

      if (room.isPlaying) {
        throw new Error('Game is already in progress');
      }

      if (room.players.length >= room.occupancy) {
        throw new Error('Room is full');
      }

      const hostSymbol = room.players[0].symbol;

      const guestSymbol = hostSymbol === 'x'
        ? 'o'
        : 'x';

      room.players.push({
        name: playerName,
        symbol: guestSymbol,
        socketId: socket.id,
        points: 0,
      });

      room.occupancy = room.players.length;
      room.isPlaying = true;
      room.turnIndex = 0;
      room.turn = room.players[room.turnIndex];

      await room.save();

      // Join Socket.IO room.
      socket.join(room.code);

      return room;
    } catch (error) {
      throw error;
    }
  }

  async makeMove({
    roomCode,
    index,
    socket,
  }) {
    const code = roomCode.trim().toUpperCase();

    const room = await Room.findOne({
      code,
    });

    if (!room) {
      throw new Error('Room not found');
    }

    if (!room.isPlaying) {
      throw new Error("Game hasn't started");
    }

    // Validate board index.
    if (index < 0 || index >= room.boardSize) {
      throw new Error('Invalid board position');
    }

    // Find the player making the move.
    const playerIndex = room.players.findIndex(
      (player) => player.socketId === socket.id,
    );

    if (playerIndex === -1) {
      throw new Error('Player is not part of this room');
    }

    // Check whether it is this player's turn.
    if (room.turnIndex !== playerIndex) {
      throw new Error('Not your turn');
    }

    // Get the player who made the move.
    const player = room.players[playerIndex];

    // Prepare move data first.
    const move = {
      index,
      symbol: player.symbol,
      player
    };

    // Switch turn.
    room.turnIndex = room.turnIndex === 0 ? 1 : 0;
    room.turn = room.players[room.turnIndex];

    await room.save();

    return {
      room,
      move,
    };
  }

  async getRoom(roomCode) {
    try {
      return await Room.findOne({
        code: roomCode.trim().toUpperCase(),
      });
    } catch (error) {

      throw error;
    }
  }

  async _generateUniqueRoomCode() {
    try {
      const maxAttempts = 10;

      for (
        let attempt = 1;
        attempt <= maxAttempts;
        attempt++
      ) {
        const code = this._generateRoomCode();

        const existingRoom = await Room.exists({
          code,
        });

        if (!existingRoom) {
          return code;
        }
      }

      throw new Error(
        'Unable to generate a unique room code. Please try again.',
      );
    } catch (error) {

      throw error;
    }
  }

  _generateRoomCode() {
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

module.exports = new RoomService();