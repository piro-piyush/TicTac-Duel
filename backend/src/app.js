const express = require('express');

const Response = require('./core/utils/response');
const Logger = require('./core/utils/logger');
const roomRoutes = require('./routes/room_routes');

const {
  PORT,
  HOST,
  NODE_ENV,
} = require('./config/env');

const app = express();

app.use(express.json());

// ─────────────────────────────────────────────
// Routes
// ─────────────────────────────────────────────

app.get('/', (req, res) => {
  return Response.success(res, {
    message: 'Tic Tac Duel server is running',
  });
});

app.get('/health', (req, res) => {
  return Response.success(res, {
    message: 'Server is healthy',
  });
});

app.get('/api', (req, res) => {
  return Response.success(res, {
    message: 'Tic Tac Duel API',
  });
});

app.use('/api/rooms', roomRoutes);

// ─────────────────────────────────────────────
// Available URLs
// ─────────────────────────────────────────────

function logAvailableUrls() {
  const baseUrl = `http://localhost:${PORT}`;

  Logger.success('Available URLs:');

  Logger.info(`  Server   : ${baseUrl}`);
  Logger.info(`  Health   : ${baseUrl}/health`);
  Logger.info(`  API      : ${baseUrl}/api`);
  Logger.info(`  Rooms    : ${baseUrl}/api/rooms`);

  Logger.info(`Environment: ${NODE_ENV}`);
  Logger.info(`Host      : ${HOST}`);
  Logger.info(`Port      : ${PORT}`);
}

logAvailableUrls();

module.exports = app;