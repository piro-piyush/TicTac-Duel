import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tictac_duel/lib.dart';

class SocketService {
  SocketService({required this._url}) {
    _socket = io.io(
      _url,
      io.OptionBuilder()
          .setTransports([SocketConstants.websocketTransport])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(SocketConstants.maxReconnectionAttempts)
          .setReconnectionDelay(SocketConstants.reconnectionDelay)
          .setReconnectionDelayMax(SocketConstants.maxReconnectionDelay)
          .build(),
    );

    _registerListeners();
  }

  final String _url;

  late final io.Socket _socket;

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
      LoggerUtils.debug(SocketConstants.alreadyConnectedMessage);
      return;
    }

    LoggerUtils.info(SocketConstants.connectingMessage);

    _socket.connect();

    await _waitForConnection();

    LoggerUtils.success(SocketConstants.connectedMessage, _socket.id);
  }

  Future<void> _waitForConnection() {
    if (isConnected) {
      return Future.value();
    }

    final completer = Completer<void>();

    late final void Function(dynamic) onConnect;
    late final void Function(dynamic) onConnectError;

    void cleanup() {
      _socket.off(SocketEvents.connect, onConnect);
      _socket.off(SocketEvents.connectError, onConnectError);
    }

    onConnect = (_) {
      cleanup();

      if (!completer.isCompleted) {
        completer.complete();
      }
    };

    onConnectError = (error) {
      cleanup();

      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    };

    _socket.once(SocketEvents.connect, onConnect);
    _socket.once(SocketEvents.connectError, onConnectError);

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

    _socket.onReconnect((attempt) {
      LoggerUtils.info(SocketConstants.reconnectedMessage, attempt);
    });

    _socket.onReconnectAttempt((attempt) {
      LoggerUtils.debug(SocketConstants.reconnectAttemptMessage, attempt);
    });

    _socket.onReconnectError((error) {
      LoggerUtils.error(SocketConstants.reconnectionErrorMessage, error);
    });

    _socket.onReconnectFailed((_) {
      LoggerUtils.error(SocketConstants.reconnectionFailedMessage);
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
      LoggerUtils.warning(
        '${SocketConstants.cannotEmitMessage} "$event": '
        '${SocketConstants.notConnectedMessage}',
      );
      return;
    }

    LoggerUtils.debug(SocketConstants.emitMessage, {
      'event': event,
      'data': data,
    });

    if (data == null) {
      _socket.emit(event);
      return;
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

    LoggerUtils.info(SocketConstants.disconnectingMessage);

    _socket.disconnect();
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  void dispose() {
    if (_disposed) {
      return;
    }

    LoggerUtils.info(SocketConstants.disposingMessage);

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
