
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tictac_duel/lib.dart';

class SocketService {
  SocketService({
    required String url,
  }) {
    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection(

      )
          .build(),
    );

    _registerListeners();
  }

  late final io.Socket _socket;

  bool get isConnected => _socket.connected;

  String get socketId {
    final id = _socket.id;

    if (id == null || id.isEmpty) {
      throw StateError('Socket is not connected.');
    }

    return id;
  }

  // ===========================================================================
  // CONNECTION
  // ===========================================================================

  Future<void> connect({
    required String roomCode,
    required String playerId,
  }) async {
    if (isConnected) {
      return;
    }

    LoggerUtils.info(
      'Connecting to Socket.IO server...',
    );

    _socket.connect();

    await _waitForConnection();

    _socket.emit(
      RoomSocketEvents.connectRoom,
      {
        'roomCode': roomCode.trim().toUpperCase(),
        'playerId': playerId,
      },
    );
  }

  Future<void> _waitForConnection() {
    if (isConnected) {
      return Future.value();
    }

    final completer = Completer<void>();

    _socket.once('connect', (_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _socket.once('connect_error', (error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });

    return completer.future;
  }

  // ===========================================================================
  // LISTENERS
  // ===========================================================================

  void _registerListeners() {
    _socket.onConnect((_) {
      LoggerUtils.success(
        'Socket connected',
        _socket.id,
      );
    });

    _socket.onDisconnect((reason) {
      LoggerUtils.info(
        'Socket disconnected',
        reason,
      );
    });

    _socket.onConnectError((error) {
      LoggerUtils.error(
        'Socket connection error',
        error,
      );
    });

    _socket.onError((error) {
      LoggerUtils.error(
        'Socket error',
        error,
      );
    });
  }

  void on(
      String event,
      void Function(dynamic data) callback,
      ) {
    _socket.on(event, callback);
  }

  void off(String event) {
    _socket.off(event);
  }

  // ===========================================================================
  // EMIT
  // ===========================================================================

  void emit(
      String event,
      dynamic data,
      ) {
    if (!isConnected) {
      LoggerUtils.warning(
        'Cannot emit "$event": socket is not connected',
      );
      return;
    }

    LoggerUtils.debug(
      'Emitting socket event: $event',
      data,
    );

    _socket.emit(event, data);
  }

  // ===========================================================================
  // DISCONNECT
  // ===========================================================================

  void disconnect() {
    if (!isConnected) {
      return;
    }

    LoggerUtils.info('Disconnecting socket...');

    _socket.disconnect();
  }

  void dispose() {
    _socket.dispose();
  }
}