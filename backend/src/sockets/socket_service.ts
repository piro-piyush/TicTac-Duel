import type { Server as HttpServer } from 'http';
import {
  Server,
  Socket,
} from 'socket.io';

import Logger from '../core/utils/logger.js';
import registerRoomSocket from './room_socket.js';

class SocketService {
  private readonly io: Server;

  constructor(server: HttpServer) {
    this.io = new Server(server, {
      cors: {
        origin: '*',
      },
    });

    this._registerConnection();
  }

  private _registerConnection(): void {
    this.io.on(
      'connection',
      (socket: Socket) => {
        Logger.info(
          `Player connected: ${socket.id}`,
        );

        registerRoomSocket(
          this.io,
          socket,
        );

        socket.on(
          'disconnect',
          (reason: string) => {
            Logger.info(
              `Player disconnected: ${socket.id}`,
              { reason },
            );
          },
        );

        socket.on(
          'error',
          (error: Error) => {
            Logger.error(
              `Socket error: ${socket.id}`,
              error,
            );
          },
        );
      },
    );
  }

  getIO(): Server {
    return this.io;
  }

  async close(): Promise<void> {
    await new Promise<void>((resolve, reject) => {
      this.io.close((error) => {
        if (error) {
          reject(error);
          return;
        }

        resolve();
      });
    });
  }
}

export default SocketService;