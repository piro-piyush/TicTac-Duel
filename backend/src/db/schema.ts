import {
  boolean,
  integer,
  pgEnum,
  pgTable,
  timestamp,
  uuid,
  varchar,
} from "drizzle-orm/pg-core";

// ─────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────

export const playerSymbolEnum = pgEnum("player_symbol", [
  "x",
  "o",
]);

export const roomThemeEnum = pgEnum("room_theme", [
  "classic",
  "inferno",
  "cyber",
]);

export const roomStatusEnum = pgEnum("room_status", [
  "waiting",
  "playing",
  "result",
]);

// TypeScript types
export type PlayerSymbol =
  (typeof playerSymbolEnum.enumValues)[number];

export type RoomTheme =
  (typeof roomThemeEnum.enumValues)[number];

export type RoomStatus =
  (typeof roomStatusEnum.enumValues)[number];

// ─────────────────────────────────────────────
// Players
// ─────────────────────────────────────────────

export const players = pgTable("players", {
  id: uuid("id")
    .defaultRandom()
    .primaryKey(),

  createdAt: timestamp("created_at", {
    withTimezone: true,
  })
    .defaultNow()
    .notNull(),
});

// ─────────────────────────────────────────────
// Rooms
// ─────────────────────────────────────────────

export const rooms = pgTable("rooms", {
  id: uuid("id")
    .defaultRandom()
    .primaryKey(),

  code: varchar("code", {
    length: 6,
  })
    .notNull()
    .unique(),

  isPrivate: boolean("is_private")
    .notNull()
    .default(true),

  hostPlayerId: uuid("host_player_id")
    .notNull()
    .references(() => players.id),

  theme: roomThemeEnum("theme")
    .notNull(),

  maxRounds: integer("max_rounds")
    .notNull()
    .default(5),

  currentRound: integer("current_round")
    .notNull()
    .default(0),

  roundStatus: roomStatusEnum("round_status")
    .notNull()
    .default("waiting"),

  turnPlayerId: uuid("turn_player_id")
    .references(() => players.id),

  turnIndex: integer("turn_index")
    .notNull()
    .default(0),

  boardSize: integer("board_size")
    .notNull()
    .default(9),

  createdAt: timestamp("created_at", {
    withTimezone: true,
  })
    .defaultNow()
    .notNull(),

  updatedAt: timestamp("updated_at", {
    withTimezone: true,
  })
    .defaultNow()
    .notNull(),
});

// ─────────────────────────────────────────────
// Room Players
// ─────────────────────────────────────────────

export const roomPlayers = pgTable("room_players", {
  id: uuid("id")
    .defaultRandom()
    .primaryKey(),

  roomId: uuid("room_id")
    .notNull()
    .references(() => rooms.id, {
      onDelete: "cascade",
    }),

  playerId: uuid("player_id")
    .notNull()
    .references(() => players.id, {
      onDelete: "cascade",
    }),

  name: varchar("name", {
    length: 20,
  })
    .notNull(),

  symbol: playerSymbolEnum("symbol")
    .notNull(),

  // socketId: varchar("socket_id", {
  //   length: 100,
  // }),

  points: integer("points")
    .notNull()
    .default(0),

  isReady: boolean("is_ready")
    .notNull()
    .default(false),

  joinedAt: timestamp("joined_at", {
    withTimezone: true,
  })
    .defaultNow()
    .notNull(),
});