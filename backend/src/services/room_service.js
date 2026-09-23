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
        players: [player],

        turn: player,
        turnIndex: 0,
      });

      socket.join(room.code);

      return room;
    } catch (error) {
      Logger.error(error);
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
      const room = await this.getRoom(code);

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

      const guestSymbol =
        hostSymbol === 'x' ? 'o' : 'x';

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

      socket.join(room.code);

      return room;
    } catch (error) {
      Logger.error(error);
      throw error;
    }
  }

  async makeMove({
    roomCode,
    index,
    socket,
  }) {
    try {
      const code = roomCode.trim().toUpperCase();
      const room = await this.getRoom(code);

      if (!room) {
        throw new Error('Room not found');
      }

      if (!room.isPlaying) {
        throw new Error("Game hasn't started");
      }

      if (
        !Number.isInteger(index) ||
        index < 0 ||
        index >= room.boardSize
      ) {
        throw new Error('Invalid board position');
      }

      const playerIndex = room.players.findIndex(
        (player) => player.socketId === socket.id,
      );

      if (playerIndex === -1) {
        throw new Error('Player is not part of this room');
      }

      if (room.turnIndex !== playerIndex) {
        throw new Error('Not your turn');
      }

      const player = room.players[playerIndex];

      const move = {
        index,
        symbol: player.symbol,
      };

      room.turnIndex =
        room.turnIndex === 0 ? 1 : 0;

      room.turn = room.players[room.turnIndex];

      await room.save();

      return {
        room,
        move,
      };
    } catch (error) {
      Logger.error(error);
      throw error;
    }
  }

  async getRoom(roomCode) {
    try {
      return await Room.findOne({
        code: roomCode.trim().toUpperCase(),
      });
    } catch (error) {
      Logger.error(error);
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
      Logger.error(error);
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