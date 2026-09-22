const Room = require('../models/room_model');

class RoomService {
  async createRoom({
    playerName,
    symbol,
    theme,
    socket,
  }) {
    const roomCode = await this._generateUniqueRoomCode();
    let player = {
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
  }
  async joinRoom({
    playerName,
    roomCode,
    socket,
  }) {
    const code = roomCode.trim().toUpperCase();

    const room = await Room.findOne({ code });

    if (!room) {
      throw new Error('Room not found');
    }

    if (room.players.length >= 2) {
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
    });

    room.occupancy = room.players.length;
    room.isPlaying = true;
    room.turnIndex = 0;
    room.turn = room.players[room.turnIndex];

    await room.save();

    // Join Socket.IO room.
    socket.join(room.code);

    return room;
  }

  async getRoom(roomCode) {
    return Room.findOne({
      code: roomCode.trim().toUpperCase(),
    });
  }

  async _generateUniqueRoomCode() {
    const maxAttempts = 10;

    for (let attempt = 1; attempt <= maxAttempts; attempt++) {
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