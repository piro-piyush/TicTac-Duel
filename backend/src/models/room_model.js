const mongoose = require('mongoose');

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
            enum: ['x', 'o'],
        },

        socketId: {
            type: String,
            required: true,
        },
        points: {
            type: Number,
            default: 0,

        }
    },
    {
        _id: false,
    },
);

const roomSchema = new mongoose.Schema(
    {
        occupancy: {
            type: Number,
            default: 2
        },
        maxRounds: {
            type: Number,
            default: 5,
            min: 1,
        },

        currentRound: {
            type: Number,
            default: 1,
            min: 1,
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
            enum: [
                'classic',
                'cyberpunk',
                'neon',
            ],
        },
        players: {
            type: [playerSchema],
            validate: {
                validator: (players) => players.length <= 2,
                message: 'A room can only have two players.',
            },
        },
        isPlaying: {
            type: Boolean,
            default: false
        },
        turn: playerSchema,
        turnIndex: {
            type: Number,
            default: 0,
            min: 0,
            max: 1,
        },
        boardSize: {
            type: Number,
            default: 9,
        },
    },
    {
        timestamps: true,
    },
);

const Room = mongoose.model('Room', roomSchema);

module.exports = Room;