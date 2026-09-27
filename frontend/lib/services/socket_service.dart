import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tictac_duel/lib.dart';

class SocketService {
  SocketService({required String url})
      : _socket = io.io(
    url,
    io.OptionBuilder()
        .setTransports([SocketConstants.websocketTransport])
        .disableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(SocketConstants.maxReconnectionAttempts)
        .setReconnectionDelay(SocketConstants.reconnectionDelay)
        .setReconnectionDelayMax(SocketConstants.maxReconnectionDelay)
        .build(),
  ) {
    _registerListeners();
  }

  final io.Socket _socket;

  bool _disposed = false;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  bool get isConnected => _socket.connected;

  bool get isDisconnected => !_socket.connected;

  String? get id => _socket.id;

  String get socketId {
    final id = _socket.id;

    if (id == null || id.isEmpty) {
      throw StateError(SocketConstants.notConnectedMessage);
    }

    return id;
  }

  // ===========================================================================
  // CONNECTION
  // ===========================================================================

  Future<void> connect() async {
    _ensureNotDisposed();

    if (isConnected) {
      return;
    }

    _socket.connect();

    await _waitForConnection();
  }

  Future<void> _waitForConnection() {
    if (isConnected) {
      return Future.value();
    }

    final completer = Completer<void>();

    late final void Function(dynamic) onConnect;
    late final void Function(dynamic) onError;

    void cleanup() {
      _socket.off(SocketEvents.connect, onConnect);
      _socket.off(SocketEvents.connectError, onError);
    }

    onConnect = (_) {
      cleanup();
      if (!completer.isCompleted) {
        completer.complete();
      }
    };

    onError = (error) {
      cleanup();
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    };

    _socket.once(SocketEvents.connect, onConnect);
    _socket.once(SocketEvents.connectError, onError);

    return completer.future;
  }

  // ===========================================================================
  // LISTENERS
  // ===========================================================================

  void _registerListeners() {
    _socket.onConnect((_) {
      LoggerUtils.success(SocketConstants.connectedMessage, _socket.id);
    });

    _socket.onDisconnect((reason) {
      LoggerUtils.info(SocketConstants.disconnectedMessage, reason);
    });

    _socket.onConnectError((error) {
      LoggerUtils.error(SocketConstants.connectionErrorMessage, error);
    });

    _socket.onError((error) {
      LoggerUtils.error(SocketConstants.socketErrorMessage, error);
    });
  }

  void on(String event, void Function(dynamic data) callback) {
    _ensureNotDisposed();
    _socket.on(event, callback);
  }

  void once(String event, void Function(dynamic data) callback) {
    _ensureNotDisposed();
    _socket.once(event, callback);
  }

  void off(String event) {
    if (_disposed) {
      return;
    }

    _socket.off(event);
  }

  // ===========================================================================
  // EMIT
  // ===========================================================================

  void emit(String event, [dynamic data]) {
    _ensureNotDisposed();

    if (!isConnected) {
      throw StateError(SocketConstants.notConnectedMessage);
    }

    _socket.emit(event, data);
  }

  // ===========================================================================
  // DISCONNECT
  // ===========================================================================

  void disconnect() {
    if (_disposed || isDisconnected) {
      return;
    }

    _socket.disconnect();
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;
    _socket.dispose();
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  void _ensureNotDisposed() {
    if (_disposed) {
      throw StateError(SocketConstants.disposedMessage);
    }
  }
}
