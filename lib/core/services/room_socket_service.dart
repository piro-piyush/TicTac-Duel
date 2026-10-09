import 'package:tictac_duel/lib.dart';

class RoomSocketService {
  RoomSocketService({required this._socket});

  final SocketService _socket;

  String? get socketId => _socket.id;

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
      (data) => onCreated(RoomCreatedResponse.fromSocket(data)),
    );

    _onMessageEvent(RoomSocketEvents.roomError, onError);

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
      (data) => onJoined(RoomJoinedResponse.fromSocket(data)),
    );

    _onMessageEvent(RoomSocketEvents.roomError, onError);

    _socket.emit(RoomSocketEvents.joinRoom, {
      'roomCode': roomCode,
      'name': name,
    });
  }

  void startGame() => _socket.emit(RoomSocketEvents.startGame);

  void quitGame() => _socket.emit(RoomSocketEvents.quitGame);

  void setReady() => _socket.emit(RoomSocketEvents.setReady);

  void sendReaction(GameReaction reaction) =>
      _socket.emit(RoomSocketEvents.sendReaction, {'reaction': reaction.emoji});

  void makeMove(int index) =>
      _socket.emit(RoomSocketEvents.makeMove, {'index': index});

  void submitGameResult([List<int> winningIndexes = const []]) => _socket.emit(
    RoomSocketEvents.submitGameResult,
    {'winningIndexes': winningIndexes},
  );

  void onPlayerJoined(void Function(PlayerJoinedResponse response) callback) =>
      _socket.on(
        RoomSocketEvents.playerJoined,
        (data) => callback(PlayerJoinedResponse.fromSocket(data)),
      );

  void onPlayerLeft(void Function(String playerId) callback) => _socket.on(
    RoomSocketEvents.playerLeft,
    (data) => callback(data as String),
  );

  void onRoomClosed(void Function(GameDismissReason reason) callback) =>
      _onMessageEvent(
        RoomSocketEvents.roomClosed,
        (response) => callback(GameDismissReason.values.byName(response)),
      );

  void onRoomError(void Function(String message) callback) =>
      _onMessageEvent(RoomSocketEvents.roomError, callback);

  void onReadyUpdated(void Function(ReadyUpdatedResponse response) callback) =>
      _socket.on(
        RoomSocketEvents.readyUpdated,
        (data) => callback(ReadyUpdatedResponse.fromSocket(data)),
      );

  void onRoundStarted(void Function(RoundStartedResponse response) callback) =>
      _socket.on(
        RoomSocketEvents.roundStarted,
        (data) => callback(RoundStartedResponse.fromSocket(data)),
      );

  void onGameDismissed(
    void Function(GameDismissedResponse response) callback,
  ) => _socket.on(
    RoomSocketEvents.gameDismissed,
    (data) => callback(GameDismissedResponse.fromSocket(data)),
  );

  void onMoveMade(void Function(MoveResultResponse response) callback) =>
      _socket.on(
        RoomSocketEvents.moveMade,
        (data) => callback(MoveResultResponse.fromSocket(data)),
      );

  void onRoundResult(void Function(RoundResultResponse response) callback) =>
      _socket.on(
        RoomSocketEvents.roundResult,
        (data) => callback(RoundResultResponse.fromSocket(data)),
      );

  void onGameError(void Function(String message) callback) =>
      _onMessageEvent(RoomSocketEvents.gameError, callback);

  void onReactionReceived(
    void Function(ReactionReceivedResponse event) callback,
  ) => _socket.on(
    RoomSocketEvents.reactionReceived,
    (data) => callback(ReactionReceivedResponse.fromSocket(data)),
  );

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

  void offCreateRoomListeners() {
    _socket.off(RoomSocketEvents.roomCreated);
    _socket.off(RoomSocketEvents.roomError);
  }

  void offJoinRoomListeners() {
    _socket.off(RoomSocketEvents.roomJoined);
    _socket.off(RoomSocketEvents.roomError);
  }

  void _onMessageEvent(String event, void Function(String message) callback) =>
      _socket.on(event, (response) => callback(response as String));
}
