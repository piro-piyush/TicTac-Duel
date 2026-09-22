require('dotenv').config();

const http = require('http');

const app = require('./src/app');
const Logger = require('./src/core/utils/logger');
const connectDatabase = require('./src/database/database');
const SocketService = require('./src/sockets/socket_service');

const {
  PORT,
  HOST,
  NODE_ENV,
} = require('./src/config/env');

const server = http.createServer(app);

// Start Socket.IO / WebSocket layer
const socketService = new SocketService(server);

async function startServer() {
  try {
    await connectDatabase();

    server.listen(PORT, HOST, () => {
      const baseUrl = `http://localhost:${PORT}`;

      Logger.success('Tic Tac Duel server started');

      Logger.info('Server Information');
      Logger.info(`  Environment : ${NODE_ENV}`);
      Logger.info(`  Host        : ${HOST}`);
      Logger.info(`  Port        : ${PORT}`);

      Logger.info('HTTP URLs');
      Logger.info(`  Server      : ${baseUrl}`);
      Logger.info(`  Health      : ${baseUrl}/health`);
      Logger.info(`  API         : ${baseUrl}/api`);
      Logger.info(`  Rooms       : ${baseUrl}/api/rooms`);

      Logger.info('Socket.IO');
      Logger.info(`  WebSocket   : ws://localhost:${PORT}`);
      Logger.info(`  Socket.IO   : ${baseUrl}/socket.io/`);
    });
  } catch (error) {
    Logger.error(
      'Failed to start server',
      error,
    );

    process.exit(1);
  }
}

async function shutdown(signal) {
  Logger.info(`${signal} received. Shutting down...`);

  try {
    await socketService.close();
    await connectDatabase.close?.();

    server.close(() => {
      Logger.success('Server shut down successfully');
      process.exit(0);
    });
  } catch (error) {
    Logger.error(
      'Error during shutdown',
      error,
    );

    process.exit(1);
  }
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

startServer();