import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tictac_duel/lib.dart';

class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  io.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  String get socketId {
    final id = _socket?.id;

    if (id == null || id.isEmpty) {
      throw StateError('Socket is not connected.');
    }

    return id;
  }

  Future<void> connect() async {
    if (isConnected) {
      return;
    }

    if (_socket == null) {
      _socket = io.io(
        dotenv.get("SOCKET_URL", fallback: 'http://localhost:3000'),
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableReconnection()
            .build(),
      );

      _registerListeners();
    }

    if (isConnected) {
      return;
    }

    LoggerUtils.info('Connecting to Socket.IO server...');

    _socket!.connect();

    await _waitForConnection();
  }

  Future<void> _waitForConnection() {
    if (isConnected) {
      return Future.value();
    }

    final completer = Completer<void>();

    _socket!.once('connect', (_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _socket!.once('connect_error', (error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });

    return completer.future;
  }

  void _registerListeners() {
    _socket!.onConnect((_) {
      LoggerUtils.success('Socket connected', _socket!.id);
    });

    _socket!.onDisconnect((reason) {
      LoggerUtils.info('Socket disconnected', reason);
    });

    _socket!.onConnectError((error) {
      LoggerUtils.error('Socket connection error', error);
    });

    _socket!.onError((error) {
      LoggerUtils.error('Socket error', error);
    });
  }

  void emit(String event, dynamic data) {
    if (!isConnected) {
      LoggerUtils.warning('Cannot emit "$event": socket is not connected');
      return;
    }

    LoggerUtils.debug('Emitting socket event: $event', data);

    _socket!.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void disconnect() {
    if (!isConnected) {
      return;
    }

    LoggerUtils.info('Disconnecting socket...');

    _socket!.disconnect();
  }
}
