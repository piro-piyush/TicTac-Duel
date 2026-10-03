import 'package:tictac_duel/lib.dart';

class RoomSocketService {
  RoomSocketService(this._socket);

  final SocketService _socket;

  // ===========================================================================
  // CONNECTION
  // ===========================================================================

  Future<void> connect({
    required String roomCode,
    required String playerId,
    required void Function(RoomConnectedResponse response) onConnected,
  }) async {
    _socket.on(
      RoomSocketEvents.roomConnected,
      (response) => _onRoomConnectedResponse(response, onConnected),
    );

    await _socket.connect();

    connectRoom(roomCode: roomCode, playerId: playerId);
  }

  void disconnect() => _socket.disconnect();

  // ===========================================================================
  // ROOM REQUESTS
  // ===========================================================================

  void connectRoom({required String roomCode, required String playerId}) =>
      _socket.emit(RoomSocketEvents.connectRoom, {
        'roomCode': roomCode,
        'playerId': playerId,
      });

  void startGame({required String roomCode}) =>
      _socket.emit(RoomSocketEvents.startGame, {'roomCode': roomCode});

  void setReady({required String roomCode}) =>
      _socket.emit(RoomSocketEvents.setReady, {'roomCode': roomCode});

  // ===========================================================================
  // GAME REQUESTS
  // ===========================================================================

  void makeMove({
    required String roomCode,
    required int index,
    required String playerId,
  }) => _socket.emit(RoomSocketEvents.makeMove, {
    'roomCode': roomCode,
    'index': index,
    'playerId': playerId,
  });

  void submitGameResult({
    required String roomCode,
    required String playerId,
    List<int> winningIndexes = const [],
  }) {
    _socket.emit(RoomSocketEvents.submitGameResult, {
      'roomCode': roomCode,
      'playerId': playerId,
      'winningIndexes': winningIndexes,
    });
  }

  // ===========================================================================
  // ROOM EVENTS
  // ===========================================================================

  void onPlayerJoined(void Function(PlayerJoinedResponse response) callback) =>
      _onPlayerEvent(RoomSocketEvents.playerJoined, callback);

  void onPlayerLeft(void Function(String playerId) callback) {
    _socket.on(
      RoomSocketEvents.playerLeft,
      (response) => _onPlayerLeftResponse(response, callback),
    );
  }

  void onRoomClosed(void Function(String reason) callback) =>
      _onMessageEvent(RoomSocketEvents.roomClosed, callback, field: 'reason');

  // ===========================================================================
  // READY EVENTS
  // ===========================================================================

  void onReadyUpdated(void Function(RoomModel room) callback) =>
      _onRoomEvent(RoomSocketEvents.readyUpdated, callback);

  void onRoundStarted(void Function(RoomModel room) callback) =>
      _onRoomEvent(RoomSocketEvents.roundStarted, callback);

  // ===========================================================================
  // GAME EVENTS
  // ===========================================================================

  void onGameDismissed(
    void Function(GameDismissedResponse response) callback,
  ) => _onResponseEvent(
    RoomSocketEvents.gameDismissed,
    GameDismissedResponse.fromJson,
    callback,
  );

  void onMoveMade(void Function(MoveResultResponse response) callback) =>
      _onResponseEvent(
        RoomSocketEvents.moveMade,
        MoveResultResponse.fromJson,
        callback,
      );

  void onRoundResult(void Function(RoundResultResponse response) callback) =>
      _onResponseEvent(
        RoomSocketEvents.roundResult,
        RoundResultResponse.fromJson,
        callback,
      );

  void _onPlayerLeftResponse(
    dynamic response,
    void Function(String playerId) callback,
  ) {
    final data = _data(response);

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid player left response');
    }

    final playerId = data['playerId'];

    if (playerId is! String || playerId.isEmpty) {
      throw const FormatException('Invalid player ID');
    }

    callback(playerId);
  }

  // ===========================================================================
  // ERROR EVENTS
  // ===========================================================================

  void onRoomError(void Function(String message) callback) =>
      _onError(RoomSocketEvents.roomError, callback);

  // ===========================================================================
  // LISTENER MANAGEMENT
  // ===========================================================================

  void off(String event) => _socket.off(event);

  void offReadyUpdated() => off(RoomSocketEvents.readyUpdated);

  void offRoundStarted() => off(RoomSocketEvents.roundStarted);

  void offGameDismissed() => off(RoomSocketEvents.gameDismissed);

  void offMoveMade() => off(RoomSocketEvents.moveMade);

  void offRoundResult() => off(RoomSocketEvents.roundResult);

  void offPlayerJoined() => off(RoomSocketEvents.playerJoined);

  void offPlayerLeft() => off(RoomSocketEvents.playerLeft);

  void offRoomClosed() => off(RoomSocketEvents.roomClosed);

  void offRoomError() => off(RoomSocketEvents.roomError);

  void dispose() => _socket.dispose();

  // ===========================================================================
  // PARSING
  // ===========================================================================

  void _onRoomEvent(String event, void Function(RoomModel room) callback) =>
      _socket.on(event, (response) => _onRoomResponse(response, callback));

  void _onRoomResponse(
    dynamic response,
    void Function(RoomModel room) callback,
  ) {
    final data = _data(response);

    if (data == null) return;

    try {
      callback(RoomModel.fromJson(data));
    } catch (_) {
      return;
    }
  }

  void _onPlayerEvent(
    String event,
    void Function(PlayerJoinedResponse response) callback,
  ) {
    _socket.on(event, (response) {
      final data = _data(response);

      if (data == null) return;

      try {
        callback(PlayerJoinedResponse.fromJson(data));
      } catch (_) {
        return;
      }
    });
  }

  void _onRoomConnectedResponse(
    dynamic response,
    void Function(RoomConnectedResponse response) callback,
  ) {
    final data = _data(response);

    if (data == null) return;

    try {
      callback(RoomConnectedResponse.fromJson(data));
    } catch (_) {
      return;
    }
  }

  void _onResponseEvent<T>(
    String event,
    T Function(dynamic json) parser,
    void Function(T response) callback,
  ) => _socket.on(event, (response) {
    final data = _data(response);

    if (data == null) return;

    try {
      callback(parser(data));
    } catch (_) {
      return;
    }
  });

  void _onMessageEvent(
    String event,
    void Function(String message) callback, {
    String field = 'message',
  }) => _socket.on(event, (response) {
    final data = _data(response);
    final message = data?[field];

    callback(
      message is String && message.isNotEmpty
          ? message
          : SocketConstants.genericErrorMessage,
    );
  });

  void _onError(String event, void Function(String message) callback) {
    _socket.on(event, (response) {
      final data = _data(response);

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid socket error response');
      }

      final message = data['message'];

      if (message is! String || message.trim().isEmpty) {
        throw const FormatException('Invalid socket error message');
      }

      callback(message);
    });
  }

  Map<String, dynamic>? _data(dynamic response) {
    if (response is! Map || response['success'] != true) {
      return null;
    }

    final data = response['data'];

    if (data is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(data);
  }
}
