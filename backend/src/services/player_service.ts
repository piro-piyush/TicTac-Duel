import { eq } from "drizzle-orm";

import { db } from "../db/index.js";
import { players } from "../db/schema.js";

interface InitializePlayerParams {
    playerId: string;
}

class PlayerService {
    async initializePlayer({
        playerId,
    }: InitializePlayerParams) {
        const normalizedPlayerId = playerId.trim();

        if (!this._isValidUuid(normalizedPlayerId)) {
            throw new Error("Invalid player ID");
        }

        try {
            const [player] = await db
                .insert(players)
                .values({
                    id: normalizedPlayerId,
                })
                .onConflictDoNothing({
                    target: players.id,
                })
                .returning();

            if (player) {
                return player;
            }

            const existingPlayer = await this.getPlayer(normalizedPlayerId);

            if (!existingPlayer) {
                throw new Error("Failed to initialize player");
            }

            return existingPlayer;
        } catch (error) {
            console.error("PLAYER INITIALIZATION ERROR:");
            console.error(error);

            throw error;
        }
    }
    async getPlayer(playerId: string) {
        const normalizedPlayerId = playerId.trim();

        if (!this._isValidUuid(normalizedPlayerId)) {
            return null;
        }

        const [player] = await db
            .select()
            .from(players)
            .where(eq(players.id, normalizedPlayerId))
            .limit(1);

        return player ?? null;
    }

    async getPlayers() {
        return db
            .select()
            .from(players);
    }

    async deletePlayer(playerId: string) {
        const normalizedPlayerId = playerId.trim();

        if (!this._isValidUuid(normalizedPlayerId)) {
            return null;
        }

        const [player] = await db
            .delete(players)
            .where(eq(players.id, normalizedPlayerId))
            .returning();

        return player ?? null;
    }

    private _isValidUuid(value: string): boolean {
        return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
            value,
        );
    }
}

export default new PlayerService();