require('dotenv').config();

const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const { Server } = require('socket.io');

const Response = require('./src/core/utils/response');
const Logger = require('./src/core/utils/logger');

const PORT = Number(process.env.PORT) || 3000;
const HOST = process.env.HOST || '0.0.0.0';
const NODE_ENV = process.env.NODE_ENV || 'development';
const MONGODB_URI = process.env.MONGODB_URI;

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

// ─────────────────────────────────────────────
// Middleware
// ─────────────────────────────────────────────

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
    data: {
      environment: NODE_ENV,
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
      database: mongoose.connection.readyState === 1
        ? 'connected'
        : 'disconnected',
    },
  });
});

// ─────────────────────────────────────────────
// Database
// ─────────────────────────────────────────────

async function connectDatabase() {
  if (!MONGODB_URI) {
    throw new Error('MONGODB_URI is not defined');
  }

  await mongoose.connect(MONGODB_URI);

  Logger.success('MongoDB connected');
}

// ─────────────────────────────────────────────
// Socket.IO
// ─────────────────────────────────────────────

io.on('connection', (socket) => {
  Logger.info(`Player connected: ${socket.id}`);

  socket.on('disconnect', (reason) => {
    Logger.info(
      `Player disconnected: ${socket.id}`,
      { reason },
    );
  });

  socket.on('error', (error) => {
    Logger.error(
      `Socket error: ${socket.id}`,
      error,
    );
  });
});

// ─────────────────────────────────────────────
// Server
// ─────────────────────────────────────────────

async function startServer() {
  try {
    await connectDatabase();

    server.listen(PORT, HOST, () => {
      Logger.success(
        `Tic Tac Duel server running at http://localhost:${PORT}`,
      );

      Logger.info(
        `Health check available at http://localhost:${PORT}/health`,
      );

      Logger.info(
        `Environment: ${NODE_ENV}`,
      );
    });
  } catch (error) {
    Logger.error(
      'Failed to start server',
      error,
    );

    process.exit(1);
  }
}

// ─────────────────────────────────────────────
// Process Events
// ─────────────────────────────────────────────

async function shutdown(signal) {
  Logger.info(`${signal} received. Shutting down server...`);

  try {
    await mongoose.connection.close();

    server.close(() => {
      Logger.success('Server shut down successfully');
      process.exit(0);
    });
  } catch (error) {
    Logger.error(
      'Error while shutting down server',
      error,
    );

    process.exit(1);
  }
}

process.on('SIGINT', () => shutdown('SIGINT'));

process.on('SIGTERM', () => shutdown('SIGTERM'));

// ─────────────────────────────────────────────
// Start
// ─────────────────────────────────────────────

startServer();