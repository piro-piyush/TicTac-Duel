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
      (response) => _handleRoomConnected(response, onConnected),
    );

    await _socket.connect();

    connectRoom(roomCode: roomCode, playerId: playerId);
  }

  void disconnect() => _socket.disconnect();

  void dispose() => _socket.dispose();

  // ===========================================================================
  // ROOM REQUESTS
  // ===========================================================================

  void connectRoom({required String roomCode, required String playerId}) {
    _socket.emit(RoomSocketEvents.connectRoom, {
      'roomCode': roomCode,
      'playerId': playerId,
    });
  }

  void startGame({required String roomCode}) {
    _socket.emit(RoomSocketEvents.startGame, {'roomCode': roomCode});
  }

  void quitGame({required String roomCode, required String playerId}) {
    _socket.emit(RoomSocketEvents.quitGame, {
      'roomCode': roomCode,
      'playerId': playerId,
    });
  }

  void setReady({required String roomCode}) {
    _socket.emit(RoomSocketEvents.setReady, {'roomCode': roomCode});
  }

  // ===========================================================================
  // GAME REQUESTS
  // ===========================================================================

  void makeMove({
    required String roomCode,
    required int index,
    required String playerId,
  }) {
    _socket.emit(RoomSocketEvents.makeMove, {
      'roomCode': roomCode,
      'index': index,
      'playerId': playerId,
    });
  }

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

  void onPlayerJoined(void Function(PlayerJoinedResponse response) callback) {
    _onPlayerEvent(RoomSocketEvents.playerJoined, callback);
  }

  void onPlayerLeft(void Function(String playerId) callback) {
    _socket.on(
      RoomSocketEvents.playerLeft,
      (response) => _handlePlayerLeft(response, callback),
    );
  }

  void onRoomClosed(void Function(String reason) callback) {
    _onMessageEvent(RoomSocketEvents.roomClosed, callback, field: 'reason');
  }

  // ===========================================================================
  // READY / ROUND EVENTS
  // ===========================================================================

  void onReadyUpdated(void Function(ReadyUpdatedResponse room) callback) {
    _onResponseEvent(
      RoomSocketEvents.readyUpdated,
      ReadyUpdatedResponse.fromJson,
      callback,
    );
  }

  void onRoundStarted(void Function(RoundStartedResponse room) callback) {
    _onResponseEvent(
      RoomSocketEvents.roundStarted,
      RoundStartedResponse.fromJson,
      callback,
    );
  }

  // ===========================================================================
  // GAME EVENTS
  // ===========================================================================

  void onGameDismissed(void Function(GameDismissedResponse response) callback) {
    _onResponseEvent(
      RoomSocketEvents.gameDismissed,
      GameDismissedResponse.fromJson,
      callback,
    );
  }

  void onMoveMade(void Function(MoveResultResponse response) callback) {
    _onResponseEvent(
      RoomSocketEvents.moveMade,
      MoveResultResponse.fromJson,
      callback,
    );
  }

  void onRoundResult(void Function(RoundResultResponse response) callback) {
    _onResponseEvent(
      RoomSocketEvents.roundResult,
      RoundResultResponse.fromJson,
      callback,
    );
  }

  // ===========================================================================
  // ERROR EVENTS
  // ===========================================================================

  void onRoomError(void Function(String message) callback) {
    _onError(RoomSocketEvents.roomError, callback);
  }

  // ===========================================================================
  // LISTENER MANAGEMENT
  // ===========================================================================

  void off(String event) => _socket.off(event);

  void offRoomConnected() => off(RoomSocketEvents.roomConnected);

  void offPlayerJoined() => off(RoomSocketEvents.playerJoined);

  void offPlayerLeft() => off(RoomSocketEvents.playerLeft);

  void offRoomClosed() => off(RoomSocketEvents.roomClosed);

  void offReadyUpdated() => off(RoomSocketEvents.readyUpdated);

  void offRoundStarted() => off(RoomSocketEvents.roundStarted);

  void offGameDismissed() => off(RoomSocketEvents.gameDismissed);

  void offMoveMade() => off(RoomSocketEvents.moveMade);

  void offRoundResult() => off(RoomSocketEvents.roundResult);
  void offSendReaction() => off(RoomSocketEvents.sendReaction);
  void offReactionReceived() => off(RoomSocketEvents.reactionReceived);

  void offRoomError() => off(RoomSocketEvents.roomError);

  // ===========================================================================
  // ROOM CONNECTED
  // ===========================================================================

  void _handleRoomConnected(
    dynamic response,
    void Function(RoomConnectedResponse response) callback,
  ) {
    final data = _tryExtractData(
      event: RoomSocketEvents.roomConnected,
      response: response,
    );

    if (data == null) {
      return;
    }

    try {
      final parsedResponse = RoomConnectedResponse.fromJson(data);

      _invokeCallback(
        event: RoomSocketEvents.roomConnected,
        callback: () => callback(parsedResponse),
      );
    } catch (error, stackTrace) {
      _logParseError(
        event: RoomSocketEvents.roomConnected,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // PLAYER EVENTS
  // ===========================================================================

  void _handlePlayerLeft(
    dynamic response,
    void Function(String playerId) callback,
  ) {
    final data = _tryExtractData(
      event: RoomSocketEvents.playerLeft,
      response: response,
    );

    if (data == null) {
      return;
    }

    try {
      final playerId = data['playerId'];

      if (playerId is! String || playerId.isEmpty) {
        throw const FormatException('Invalid player ID');
      }

      _invokeCallback(
        event: RoomSocketEvents.playerLeft,
        callback: () => callback(playerId),
      );
    } catch (error, stackTrace) {
      _logParseError(
        event: RoomSocketEvents.playerLeft,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // GENERIC ROOM EVENTS
  // ===========================================================================
  //
  // void _onRoomEvent(String event, void Function(RoomModel room) callback) {
  //   _socket.on(
  //     event,
  //     (response) => _handleRoomResponse(event, response, callback),
  //   );
  // }

  // void _handleRoomResponse(
  //   String event,
  //   dynamic response,
  //   void Function(RoomModel room) callback,
  // ) {
  //   final data = _tryExtractData(event: event, response: response);
  //
  //   if (data == null) {
  //     return;
  //   }
  //
  //   try {
  //     final room = RoomModel.fromJson(data);
  //
  //     _invokeCallback(event: event, callback: () => callback(room));
  //   } catch (error, stackTrace) {
  //     _logParseError(event: event, error: error, stackTrace: stackTrace);
  //   }
  // }

  // ===========================================================================
  // PLAYER RESPONSE EVENTS
  // ===========================================================================

  void _onPlayerEvent(
    String event,
    void Function(PlayerJoinedResponse response) callback,
  ) {
    _socket.on(
      event,
      (response) => _handlePlayerResponse(event, response, callback),
    );
  }

  void _handlePlayerResponse(
    String event,
    dynamic response,
    void Function(PlayerJoinedResponse response) callback,
  ) {
    final data = _tryExtractData(event: event, response: response);

    if (data == null) {
      return;
    }

    try {
      final playerResponse = PlayerJoinedResponse.fromJson(data);

      _invokeCallback(event: event, callback: () => callback(playerResponse));
    } catch (error, stackTrace) {
      _logParseError(event: event, error: error, stackTrace: stackTrace);
    }
  }

  // ===========================================================================
  // GENERIC RESPONSE EVENTS
  // ===========================================================================

  void _onResponseEvent<T>(
    String event,
    T Function(dynamic json) parser,
    void Function(T response) callback,
  ) {
    _socket.on(
      event,
      (response) => _handleResponse(event, response, parser, callback),
    );
  }

  void _handleResponse<T>(
    String event,
    dynamic response,
    T Function(dynamic json) parser,
    void Function(T response) callback,
  ) {
    final data = _tryExtractData(event: event, response: response);

    if (data == null) {
      return;
    }

    try {
      LoggerUtils.debug('Socket event data: $event | $data');

      final parsedResponse = parser(data);

      _invokeCallback(event: event, callback: () => callback(parsedResponse));
    } catch (error, stackTrace) {
      _logParseError(event: event, error: error, stackTrace: stackTrace);
    }
  }

  // ===========================================================================
  // MESSAGE EVENTS
  // ===========================================================================

  void _onMessageEvent(
    String event,
    void Function(String message) callback, {
    String field = 'message',
  }) {
    _socket.on(
      event,
      (response) => _handleMessageResponse(event, response, callback, field),
    );
  }

  void _handleMessageResponse(
    String event,
    dynamic response,
    void Function(String message) callback,
    String field,
  ) {
    final data = _tryExtractData(event: event, response: response);

    if (data == null) {
      return;
    }

    try {
      final message = data[field];

      final resolvedMessage = message is String && message.trim().isNotEmpty
          ? message
          : SocketConstants.genericErrorMessage;

      _invokeCallback(event: event, callback: () => callback(resolvedMessage));
    } catch (error, stackTrace) {
      _logParseError(event: event, error: error, stackTrace: stackTrace);
    }
  }

  // ===========================================================================
  // ERROR EVENTS
  // ===========================================================================

  void _onError(String event, void Function(String message) callback) {
    _socket.on(
      event,
      (response) => _handleErrorResponse(event, response, callback),
    );
  }

  void _handleErrorResponse(
    String event,
    dynamic response,
    void Function(String message) callback,
  ) {
    try {
      final data = _unwrapErrorData(response);

      final message = data['message'];

      if (message is! String || message.trim().isEmpty) {
        throw const FormatException('Invalid socket error message');
      }

      _invokeCallback(event: event, callback: () => callback(message));
    } catch (error, stackTrace) {
      _logParseError(event: event, error: error, stackTrace: stackTrace);
    }
  }

  // ===========================================================================
  // CALLBACK ERROR HANDLING
  // ===========================================================================

  void _invokeCallback({
    required String event,
    required void Function() callback,
  }) {
    try {
      callback();
    } catch (error, stackTrace) {
      LoggerUtils.error('Socket callback failed for $event: $error');

      LoggerUtils.debug(stackTrace.toString());
    }
  }

  // ===========================================================================
  // PARSE ERROR HANDLING
  // ===========================================================================

  void _logParseError({
    required String event,
    required Object error,
    required StackTrace stackTrace,
  }) {
    LoggerUtils.error('Failed to parse $event response: $error');

    LoggerUtils.debug(stackTrace.toString());
  }

  // ===========================================================================
  // DATA EXTRACTION
  // ===========================================================================

  Map<String, dynamic>? _tryExtractData({
    required String event,
    required dynamic response,
  }) {
    try {
      final data = _data(response);

      if (data == null) {
        LoggerUtils.error('Invalid socket response for $event | $response');

        return null;
      }

      return data;
    } catch (error, stackTrace) {
      _logParseError(event: event, error: error, stackTrace: stackTrace);

      return null;
    }
  }

  Map<String, dynamic>? _data(dynamic response) {
    if (response is! Map) {
      return null;
    }

    if (response['success'] != true) {
      return null;
    }

    final data = response['data'];

    if (data is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(data);
  }

  Map<String, dynamic> _unwrapErrorData(dynamic response) {
    dynamic data = response;

    if (data is List) {
      if (data.isEmpty) {
        throw const FormatException('Invalid socket error response');
      }

      data = data.first;
    }

    if (data is! Map) {
      throw const FormatException('Invalid socket error response');
    }

    return Map<String, dynamic>.from(data);
  }

  // ===========================================================================
// REACTIONS
// ===========================================================================

  void sendReaction({
    required String roomCode,
    required String senderId,
    required String targetPlayerId,
    required GameReaction reaction,
  }) {
    _socket.emit(RoomSocketEvents.sendReaction, {
      'roomCode': roomCode,
      'senderId': senderId,
      'targetPlayerId': targetPlayerId,
      'reaction': reaction.name,
    });
  }

  void onReactionReceived(
      void Function(GameReactionEvent event) callback,
      ) {
    _onResponseEvent(
      RoomSocketEvents.reactionReceived,
      GameReactionEvent.fromJson,
      callback,
    );
  }
}
