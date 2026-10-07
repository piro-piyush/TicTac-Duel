import 'package:tictac_duel/lib.dart';

class RoomSocketService {
  RoomSocketService({required this._socket});

  final SocketService _socket;

  String get socketId => _socket.socketId;

  Future<void> connect() => _socket.connect();

  void disconnect() => _socket.disconnect();

  void dispose() => _socket.dispose();

  void createRoom({
    required String name,
    required PlayerSymbol symbol,
    required int maxRounds,
    required RoomTheme theme,
    required bool isPrivate,
    required void Function(RoomCreatedResponse response) onCreated,
    required void Function(String message) onError,
  }) {
    _socket.off(RoomSocketEvents.roomCreated);
    _socket.off(RoomSocketEvents.roomError);

    _socket.on(
      RoomSocketEvents.roomCreated,
      (json) => onCreated(RoomCreatedResponse.fromJson(json)),
    );

    _socket.on(
      RoomSocketEvents.roomError,
      (response) =>
          _handleErrorResponse(RoomSocketEvents.roomError, response, onError),
    );

    _socket.emit(RoomSocketEvents.createRoom, {
      'name': name,
      'symbol': symbol.name,
      'maxRounds': maxRounds,
      'theme': theme.name,
      'isPrivate': isPrivate,
    });
  }

  void joinRoom({
    required String roomCode,
    required String name,
    required void Function(RoomJoinedResponse response) onJoined,
    required void Function(String message) onError,
  }) {
    _socket.off(RoomSocketEvents.roomJoined);
    _socket.off(RoomSocketEvents.roomError);

    _socket.on(
      RoomSocketEvents.roomJoined,
      (json) => onJoined(RoomJoinedResponse.fromJson(json)),
    );

    _socket.on(
      RoomSocketEvents.roomError,
      (response) =>
          _handleErrorResponse(RoomSocketEvents.roomError, response, onError),
    );

    _socket.emit(RoomSocketEvents.joinRoom, {
      'roomCode': roomCode,
      'name': name,
    });
  }

  void startGame({required String roomCode}) {
    _socket.emit(RoomSocketEvents.startGame, {'roomCode': roomCode});
  }

  void quitGame({required String roomCode}) {
    _socket.emit(RoomSocketEvents.quitGame, {'roomCode': roomCode});
  }

  void setReady({required String roomCode}) {
    _socket.emit(RoomSocketEvents.setReady, {'roomCode': roomCode});
  }

  void sendReaction({
    required String roomCode,
    required GameReaction reaction,
  }) {
    _socket.emit(RoomSocketEvents.sendReaction, {
      'roomCode': roomCode,
      'reaction': reaction.name,
    });
  }

  void makeMove({required String roomCode, required int index}) {
    _socket.emit(RoomSocketEvents.makeMove, {
      'roomCode': roomCode,
      'index': index,
    });
  }

  void submitGameResult({
    required String roomCode,
    List<int> winningIndexes = const [],
  }) {
    _socket.emit(RoomSocketEvents.submitGameResult, {
      'roomCode': roomCode,
      'winningIndexes': winningIndexes,
    });
  }

  void onPlayerJoined(void Function(PlayerModel player) callback) {
    _socket.on(RoomSocketEvents.playerJoined, (data) {
      callback(PlayerModel.fromSocket(data));
    });
  }

  void onPlayerLeft(void Function(String playerId) callback) {
    _socket.on(RoomSocketEvents.playerLeft, (data) => callback(data as String));
  }

  void onRoomClosed(void Function(String reason) callback) {
    _onMessageEvent(RoomSocketEvents.roomClosed, callback, field: 'reason');
  }

  void onReadyUpdated(void Function(ReadyUpdatedResponse response) callback) {
    _onResponseEvent(
      RoomSocketEvents.readyUpdated,
      ReadyUpdatedResponse.fromJson,
      callback,
    );
  }

  void onRoundStarted(void Function(RoundStartedResponse response) callback) {
    _socket.on(
      RoomSocketEvents.roundStarted,
      (data) => callback(RoundStartedResponse.fromJson(data)),
    );
  }

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

  void onRoomError(void Function(String message) callback) {
    _onError(RoomSocketEvents.roomError, callback);
  }

  void onGameError(void Function(String message) callback) {
    _onError(RoomSocketEvents.gameError, callback);
  }

  void onReactionReceived(void Function(GameReactionEvent event) callback) {
    _onResponseEvent(
      RoomSocketEvents.reactionReceived,
      GameReactionEvent.fromJson,
      callback,
    );
  }

  void off(String event) => _socket.off(event);

  void offRoomJoined() => off(RoomSocketEvents.roomJoined);

  void offPlayerJoined() => off(RoomSocketEvents.playerJoined);

  void offPlayerLeft() => off(RoomSocketEvents.playerLeft);

  void offRoomClosed() => off(RoomSocketEvents.roomClosed);

  void offReadyUpdated() => off(RoomSocketEvents.readyUpdated);

  void offRoundStarted() => off(RoomSocketEvents.roundStarted);

  void offGameDismissed() => off(RoomSocketEvents.gameDismissed);

  void offMoveMade() => off(RoomSocketEvents.moveMade);

  void offRoundResult() => off(RoomSocketEvents.roundResult);

  void offReactionReceived() => off(RoomSocketEvents.reactionReceived);

  void offRoomError() => off(RoomSocketEvents.roomError);

  void offGameError() => off(RoomSocketEvents.gameError);

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

  // void _onPlayerEvent(
  //   String event,
  //   void Function(PlayerModel response) callback,
  // ) {
  //   _socket.on(
  //     event,
  //     (response) => _handlePlayerResponse(event, response, callback),
  //   );
  // }

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
      final parsedResponse = parser(data);

      _invokeCallback(event: event, callback: () => callback(parsedResponse));
    } catch (error, stackTrace) {
      _logParseError(event: event, error: error, stackTrace: stackTrace);
    }
  }

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

  void _logParseError({
    required String event,
    required Object error,
    required StackTrace stackTrace,
  }) {
    LoggerUtils.error('Failed to parse $event response: $error');

    LoggerUtils.debug(stackTrace.toString());
  }

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
}
