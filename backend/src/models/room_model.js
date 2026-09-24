const mongoose = require('mongoose');

const PLAYER_SYMBOL = Object.freeze({
    X: 'x',
    O: 'o',
});

const ROOM_STATUS = Object.freeze({
    WAITING: 'waiting',
    PLAYING: 'playing',
    RESULT: 'result',
});

const ROOM_THEME = Object.freeze({
    CLASSIC: 'classic',
    CYBERPUNK: 'cyberpunk',
    NEON: 'neon',
});

const playerSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
            trim: true,
            minlength: 2,
            maxlength: 20,
        },
        symbol: {
            type: String,
            required: true,
            enum: Object.values(PLAYER_SYMBOL),
        },
        socketId: {
            type: String,
            required: true,
        },
        points: {
            type: Number,
            default: 0,
            min: 0,
        },
        isReady: {
            type: Boolean,
            default: false,
        },
    },
    {
        _id: false,
    },
);

const roomSchema = new mongoose.Schema(
    {
        occupancy: {
            type: Number,
            default: 0,
            min: 0,
            max: 2,
        },
        maxRounds: {
            type: Number,
            default: 5,
            min: 1,
        },
        currentRound: {
            type: Number,
            default: 0,
            min: 0,
        },
        code: {
            type: String,
            required: true,
            unique: true,
            uppercase: true,
            trim: true,
            minlength: 6,
            maxlength: 6,
        },
        theme: {
            type: String,
            required: true,
            enum: Object.values(ROOM_THEME),
        },
        players: {
            type: [playerSchema],
            validate: {
                validator: (players) => players.length <= 2,
                message: 'A room can only have two players.',
            },
        },
        roundStatus: {
            type: String,
            enum: Object.values(ROOM_STATUS),
            default: ROOM_STATUS.WAITING,
        },
        turn: {
            type: playerSchema,
            default: null,
        },
        turnIndex: {
            type: Number,
            default: 0,
            min: 0,
            max: 1,
        },
        boardSize: {
            type: Number,
            default: 9,
            min: 4,
        },
    },
    {
        timestamps: true,
        strict: true,
    },
);

const Room = mongoose.model('Room', roomSchema);

module.exports = {
    Room,
    PLAYER_SYMBOL,
    ROOM_STATUS,
    ROOM_THEME,
};