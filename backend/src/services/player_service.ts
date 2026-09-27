import { eq } from "drizzle-orm";

import { db } from "../db/index.js";
import { players } from "../db/schema.js";

interface InitializePlayerParams {
    id: string;
}

class PlayerService {
    async initializePlayer({
        id,
    }: InitializePlayerParams) {
        const [player] = await db
            .insert(players)
            .values({
                id: id,
            })
            .onConflictDoNothing({
                target: players.id,
            })
            .returning();

        if (player) {
            return player;
        }

        const existingPlayer = await this.getPlayer(id);

        if (!existingPlayer) {
            throw new Error("Failed to initialize player");
        }

        return existingPlayer;
    }

    async getPlayer(id: string) {
        const [player] = await db
            .select()
            .from(players)
            .where(eq(players.id, id))
            .limit(1);

        return player ?? null;
    }

    async getPlayers() {
        return db
            .select()
            .from(players);
    }

    async deletePlayer(id: string) {
        const [player] = await db
            .delete(players)
            .where(eq(players.id, id))
            .returning();

        return player ?? null;
    }
}

export default new PlayerService();