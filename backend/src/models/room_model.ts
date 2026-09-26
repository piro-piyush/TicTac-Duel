// import mongoose, {
//     Document,
//     Schema,
// } from 'mongoose';

// const PLAYER_SYMBOL = {
//     X: 'x',
//     O: 'o',
// } as const;

// type PlayerSymbol =
//     (typeof PLAYER_SYMBOL)[keyof typeof PLAYER_SYMBOL];

// const ROOM_STATUS = {
//     WAITING: 'waiting',
//     PLAYING: 'playing',
//     RESULT: 'result',
// } as const;

// type RoomStatus =
//     (typeof ROOM_STATUS)[keyof typeof ROOM_STATUS];

// const ROOM_THEME = {
//     CLASSIC: 'classic',
//     CYBERPUNK: 'cyberpunk',
//     NEON: 'neon',
// } as const;

// type RoomTheme =
//     (typeof ROOM_THEME)[keyof typeof ROOM_THEME];

// interface IPlayer {
//     name: string;
//     symbol: PlayerSymbol;
//     socketId: string;
//     points: number;
//     isReady: boolean;
// }

// interface IRoom extends Document {
//     occupancy: number;
//     maxRounds: number;
//     currentRound: number;
//     code: string;
//     theme: RoomTheme;
//     players: IPlayer[];
//     roundStatus: RoomStatus;
//     turn: IPlayer | null;
//     turnIndex: number;
//     boardSize: number;
// }

// const playerSchema = new Schema<IPlayer>(
//     {
//         name: {
//             type: String,
//             required: true,
//             trim: true,
//             minlength: 2,
//             maxlength: 20,
//         },

//         symbol: {
//             type: String,
//             required: true,
//             enum: Object.values(PLAYER_SYMBOL),
//         },

//         socketId: {
//             type: String,
//             required: true,
//         },

//         points: {
//             type: Number,
//             default: 0,
//             min: 0,
//         },

//         isReady: {
//             type: Boolean,
//             default: false,
//         },
//     },
//     {
//         _id: false,
//     },
// );

// const roomSchema = new Schema<IRoom>(
//     {
//         occupancy: {
//             type: Number,
//             default: 0,
//             min: 0,
//             max: 2,
//         },

//         maxRounds: {
//             type: Number,
//             default: 5,
//             min: 1,
//         },

//         currentRound: {
//             type: Number,
//             default: 0,
//             min: 0,
//         },

//         code: {
//             type: String,
//             required: true,
//             unique: true,
//             uppercase: true,
//             trim: true,
//             minlength: 6,
//             maxlength: 6,
//         },

//         theme: {
//             type: String,
//             required: true,
//             enum: Object.values(ROOM_THEME),
//         },

//         players: {
//             type: [playerSchema],
//             validate: {
//                 validator: (players: IPlayer[]) =>
//                     players.length <= 2,
//                 message: 'A room can only have two players.',
//             },
//         },

//         roundStatus: {
//             type: String,
//             enum: Object.values(ROOM_STATUS),
//             default: ROOM_STATUS.WAITING,
//         },

//         turn: {
//             type: playerSchema,
//             default: null,
//         },

//         turnIndex: {
//             type: Number,
//             default: 0,
//             min: 0,
//             max: 1,
//         },

//         boardSize: {
//             type: Number,
//             default: 9,
//             min: 4,
//         },
//     },
//     {
//         timestamps: true,
//         strict: true,
//     },
// );

// const Room = mongoose.model<IRoom>(
//     'Room',
//     roomSchema,
// );

// export {
//     PLAYER_SYMBOL,
//     Room,
//     ROOM_STATUS,
//     ROOM_THEME
// };

// export type {
//     IPlayer,
//     IRoom,
//     PlayerSymbol,
//     RoomStatus,
//     RoomTheme
// };
