import express, {
  Response as ExpressResponse,
  Request,
} from 'express';

import Logger from './core/utils/logger';
import Response from './core/utils/response';
import roomRoutes from './routes/room_routes';

import {
  HOST,
  NODE_ENV,
  PORT,
} from './config/env';

const app = express();

app.use(express.json());

// ─────────────────────────────────────────────
// Routes
// ─────────────────────────────────────────────

app.get(
  '/',
  (_req: Request, res: ExpressResponse) => {
    return Response.success(res, {
      message: 'Tic Tac Duel server is running',
    });
  },
);

app.get(
  '/health',
  (_req: Request, res: ExpressResponse) => {
    return Response.success(res, {
      message: 'Server is healthy',
    });
  },
);

app.get(
  '/api',
  (_req: Request, res: ExpressResponse) => {
    return Response.success(res, {
      message: 'Tic Tac Duel API',
    });
  },
);

app.use('/api/rooms', roomRoutes);

// ─────────────────────────────────────────────
// Available URLs
// ─────────────────────────────────────────────

function logAvailableUrls(): void {
  const baseUrl = `http://localhost:${PORT}`;

  Logger.success('Available URLs:');

  Logger.info(`  Server      : ${baseUrl}`);
  Logger.info(`  Health      : ${baseUrl}/health`);
  Logger.info(`  API         : ${baseUrl}/api`);
  Logger.info(`  Rooms       : ${baseUrl}/api/rooms`);
  Logger.info(`Environment   : ${NODE_ENV}`);
  Logger.info(`Host          : ${HOST}`);
  Logger.info(`Port          : ${PORT}`);
}

logAvailableUrls();

export default app;