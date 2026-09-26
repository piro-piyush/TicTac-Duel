import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Todo: Remove in production
  ssl: false,
});

export const db = drizzle(pool);

export type Database = typeof db;