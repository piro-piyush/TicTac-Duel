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
  Future<void>? _connectionFuture;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  bool get isConnected => _socket.connected;

  bool get isDisconnected => !_socket.connected;

  String? get id => _socket.id;

  String get socketId {
    final socketId = _socket.id;

    if (socketId == null || socketId.isEmpty) {
      throw StateError(SocketConstants.notConnectedMessage);
    }

    return socketId;
  }

  // ===========================================================================
  // CONNECTION
  // ===========================================================================

  Future<void> connect() async {
    _ensureNotDisposed();

    if (isConnected) {
      return;
    }

    _connectionFuture ??= _connect();

    try {
      await _connectionFuture;
    } finally {
      _connectionFuture = null;
    }
  }

  Future<void> _connect() async {
    _ensureNotDisposed();

    if (isConnected) {
      return;
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

    _socket.connect();

    await completer.future;
  }

  // ===========================================================================
  // LISTENERS
  // ===========================================================================

  void _registerListeners() {
    _socket.onConnect(_handleConnect);

    _socket.onDisconnect(_handleDisconnect);

    _socket.onConnectError(_handleConnectError);

    _socket.onError(_handleSocketError);

    // Logs every event received from the server.
    _socket.onAny(_handleIncomingEvent);

    // Logs every event emitted by the client.
    _socket.onAnyOutgoing(_handleOutgoingEvent);
  }

  void _handleConnect(dynamic _) {
    LoggerUtils.success(SocketConstants.connectedMessage, _socket.id);
  }

  void _handleDisconnect(dynamic reason) {
    LoggerUtils.info(SocketConstants.disconnectedMessage, reason);
  }

  void _handleConnectError(dynamic error) {
    LoggerUtils.error(SocketConstants.connectionErrorMessage, error);
  }

  void _handleSocketError(dynamic error) {
    LoggerUtils.error(SocketConstants.socketErrorMessage, error);
  }

  // ===========================================================================
  // SOCKET EVENT LOGGING
  // ===========================================================================

  /// Logs every event received from the server.
  void _handleIncomingEvent(String event, dynamic data) {
    try {
      LoggerUtils.info('[SOCKET ←] $event', data);
    } catch (error, stackTrace) {
      LoggerUtils.error('[SOCKET] Failed to log incoming event $event: $error');

      LoggerUtils.debug(stackTrace.toString());
    }
  }

  /// Logs every event emitted by the client.
  void _handleOutgoingEvent(String event, dynamic data) {
    try {
      LoggerUtils.info('[SOCKET →] $event', data);
    } catch (error, stackTrace) {
      LoggerUtils.error('[SOCKET] Failed to log outgoing event $event: $error');

      LoggerUtils.debug(stackTrace.toString());
    }
  }

  // ===========================================================================
  // EVENT LISTENERS
  // ===========================================================================

  void on(String event, void Function(dynamic data) callback) {
    _ensureNotDisposed();

    _socket.on(event, (data) {
      try {
        callback(data);
      } catch (error, stackTrace) {
        _handleCallbackError(
          event: event,
          error: error,
          stackTrace: stackTrace,
        );
      }
    });
  }

  void once(String event, void Function(dynamic data) callback) {
    _ensureNotDisposed();

    _socket.once(event, (data) {
      try {
        callback(data);
      } catch (error, stackTrace) {
        _handleCallbackError(
          event: event,
          error: error,
          stackTrace: stackTrace,
        );
      }
    });
  }

  void off(String event) {
    if (_disposed) {
      return;
    }

    _socket.off(event);
  }

  // ===========================================================================
  // CALLBACK ERROR HANDLING
  // ===========================================================================

  void _handleCallbackError({
    required String event,
    required Object error,
    required StackTrace stackTrace,
  }) {
    LoggerUtils.error('[SOCKET] Callback failed for $event: $error');

    LoggerUtils.debug(stackTrace.toString());
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
    _connectionFuture = null;

    _removeListeners();

    _socket.dispose();
  }

  void _removeListeners() {
    _socket.off(SocketEvents.connect);
    _socket.off(SocketEvents.disconnect);
    _socket.off(SocketEvents.connectError);
    _socket.off(SocketEvents.error);

    // Remove catch-all incoming listener.
    _socket.offAny(_handleIncomingEvent);

    // Remove catch-all outgoing listener.
    _socket.offAnyOutgoing(_handleOutgoingEvent);
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
