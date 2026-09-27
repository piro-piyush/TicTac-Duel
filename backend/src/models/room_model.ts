import type {
    PlayerSymbol,
    RoomStatus,
    RoomTheme,
} from "../db/schema.js";

export type UUID = string;

export interface PlayerModel {
    id: UUID;
    name: string;
    symbol: PlayerSymbol;
    points: number;
    isReady: boolean;
}

export interface RoomModel {
    id: UUID;
    code: string;
    isPrivate: boolean;
    hostPlayerId: UUID;
    theme: RoomTheme;
    maxRounds: number;
    currentRound: number;
    roundStatus: RoomStatus;
    turnPlayerId: UUID | null;
    turnIndex: number;
    boardSize: number;
    players: PlayerModel[];
    occupancy: number;
    createdAt: Date;
    updatedAt: Date;
}