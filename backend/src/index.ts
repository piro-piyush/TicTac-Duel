import 'dotenv/config';
import http from 'http';

import app from './app.js';
import Logger from './core/utils/logger.js';
// import connectDatabase from './database/database.js';
import SocketService from './sockets/socket_service.js';

import {
    HOST,
    NODE_ENV,
    PORT,
} from './config/env.js';

const server = http.createServer(app);

// Start Socket.IO / WebSocket layer
const socketService = new SocketService(server);

async function startServer(): Promise<void> {
    try {
        // await connectDatabase();

        server.listen(
            PORT,
            HOST,
            () => {
                const baseUrl =
                    `http://localhost:${PORT}`;

                Logger.success(
                    'Tic Tac Duel server started',
                );

                Logger.info('Server Information');
                Logger.info(
                    `  Environment : ${NODE_ENV}`,
                );
                Logger.info(`  Host        : ${HOST}`);
                Logger.info(`  Port        : ${PORT}`);

                Logger.info('HTTP URLs');
                Logger.info(
                    `  Server      : ${baseUrl}`,
                );
                Logger.info(
                    `  Health      : ${baseUrl}/health`,
                );
                Logger.info(
                    `  API         : ${baseUrl}/api`,
                );
                Logger.info(
                    `  Rooms       : ${baseUrl}/api/rooms`,
                );

                Logger.info('Socket.IO');
                Logger.info(
                    `  WebSocket   : ws://localhost:${PORT}`,
                );
                Logger.info(
                    `  Socket.IO   : ${baseUrl}/socket.io/`,
                );
            },
        );
    } catch (error: unknown) {
        Logger.error(
            'Failed to start server',
            error,
        );

        process.exit(1);
    }
}

async function shutdown(
    signal: string,
): Promise<void> {
    Logger.info(
        `${signal} received. Shutting down...`,
    );

    try {
        // Close Socket.IO
        await socketService.close();

        // Close MongoDB

        // Close HTTP server
        server.close((error) => {
            if (error) {
                Logger.error(
                    'Error closing HTTP server',
                    error,
                );

                process.exit(1);
            }

            Logger.success(
                'Server shut down successfully',
            );

            process.exit(0);
        });
    } catch (error: unknown) {
        Logger.error(
            'Error during shutdown',
            error,
        );

        process.exit(1);
    }
}

process.on(
    'SIGINT',
    () => {
        void shutdown('SIGINT');
    },
);

process.on(
    'SIGTERM',
    () => {
        void shutdown('SIGTERM');
    },
);

void startServer();