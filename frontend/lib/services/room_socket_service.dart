import 'package:tictac_duel/lib.dart';

class RoomSocketService {
  RoomSocketService(this._socket);

  final SocketService _socket;

  // ===========================================================================
  // ROOM REQUESTS
  // ===========================================================================

  void createRoom({
    required String playerName,
    required PlayerSymbol symbol,
    required RoomTheme theme,
    required int maxRounds,
  }) {
    _socket.emit(RoomSocketEvents.createRoom, {
      'playerName': playerName,
      'symbol': symbol.value,
      'theme': theme.value,
      'maxRounds': maxRounds,
    });
  }

  void joinRoom({required String roomCode, required String playerName}) {
    _socket.emit(RoomSocketEvents.joinRoom, {
      'roomCode': roomCode,
      'playerName': playerName,
    });
  }

  void leaveRoom({required String roomCode}) {
    _socket.emit(RoomSocketEvents.leaveRoom, {'roomCode': roomCode});
  }

  // ===========================================================================
  // GAME REQUESTS
  // ===========================================================================

  void makeMove({required String roomCode, required int index}) {
    _socket.emit(RoomSocketEvents.makeMove, {
      'roomCode': roomCode,
      'index': index,
    });
  }

  void submitGameResult({
    required String roomCode,
    String? winnerSocketId,
    List<int> winningIndexes = const [],
  }) {
    _socket.emit(RoomSocketEvents.submitGameResult, {
      'roomCode': roomCode,
      'winnerSocketId': winnerSocketId,
      'winningIndexes': winningIndexes,
    });
  }

  void setPlayerReady({required String roomCode}) {
    _socket.emit(RoomSocketEvents.toggleReady, {
      'roomCode': roomCode,
      'isReady': true,
    });
  }

  // ===========================================================================
  // ROOM EVENTS
  // ===========================================================================

  void onRoomCreated(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.roomCreated, callback);
  }

  void onRoomJoined(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.roomJoined, callback);
  }

  void onRoomUpdated(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.roomUpdated, callback);
  }

  // ===========================================================================
  // PLAYER EVENTS
  // ===========================================================================

  void onPlayerJoined(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.playerJoined, callback);
  }

  void onPlayerLeft(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.playerLeft, callback);
  }

  void onReadyUpdated(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.readyUpdated, callback);
  }

  // ===========================================================================
  // GAME EVENTS
  // ===========================================================================

  void onGameStarted(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.gameStarted, callback);
  }

  void onGameEnded(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.gameEnded, callback);
  }

  void onMoveMade(
    void Function({
      required RoomModel room,
      required int index,
      required PlayerSymbol symbol,
    })
    callback,
  ) {
    _socket.on(RoomSocketEvents.moveMade, (response) {
      final result = _parseMove(response);

      if (result == null) {
        return;
      }

      callback(room: result.room, index: result.index, symbol: result.symbol);
    });
  }

  void onRoundResult(
    void Function({
      required RoomModel room,
      required String winnerSocketId,
      required List<int> winningIndexes,
      required int completedRound,
      required bool gameFinished,
    })
    callback,
  ) {
    _socket.on(RoomSocketEvents.roundResult, (response) {
      final result = _parseRoundResult(response);

      if (result == null) {
        return;
      }

      callback(
        room: result.room,
        winnerSocketId: result.winnerSocketId,
        winningIndexes: result.winningIndexes,
        completedRound: result.completedRound,
        gameFinished: result.gameFinished,
      );
    });
  }

  // ===========================================================================
  // ERROR EVENTS
  // ===========================================================================

  void onRoomError(void Function(String message) callback) {
    _onMessageEvent(RoomSocketEvents.roomError, callback);
  }

  void onGameError(void Function(String message) callback) {
    _onMessageEvent(RoomSocketEvents.gameError, callback);
  }

  // ===========================================================================
  // LISTENER MANAGEMENT
  // ===========================================================================

  void off(String event) {
    _socket.off(event);
  }

  void offRoomCreated() {
    off(RoomSocketEvents.roomCreated);
  }

  void offRoomJoined() {
    off(RoomSocketEvents.roomJoined);
  }

  void offRoomUpdated() {
    off(RoomSocketEvents.roomUpdated);
  }

  void offPlayerJoined() {
    off(RoomSocketEvents.playerJoined);
  }

  void offPlayerLeft() {
    off(RoomSocketEvents.playerLeft);
  }

  void offReadyUpdated() {
    off(RoomSocketEvents.readyUpdated);
  }

  void offMoveMade() {
    off(RoomSocketEvents.moveMade);
  }

  void offRoundResult() {
    off(RoomSocketEvents.roundResult);
  }

  void offGameStarted() {
    off(RoomSocketEvents.gameStarted);
  }

  void offGameEnded() {
    off(RoomSocketEvents.gameEnded);
  }

  void offRoomError() {
    off(RoomSocketEvents.roomError);
  }

  void offGameError() {
    off(RoomSocketEvents.gameError);
  }

  // ===========================================================================
  // ROOM PARSING
  // ===========================================================================

  void _onRoomEvent(String event, void Function(RoomModel room) callback) {
    _socket.on(event, (response) {
      final room = _parseRoom(response);

      if (room != null) {
        callback(room);
      }
    });
  }

  void _onMessageEvent(String event, void Function(String message) callback) {
    _socket.on(event, (response) {
      if (response is! Map) {
        callback('Something went wrong.');
        return;
      }

      final message = response['message']?.toString();

      callback(
        message == null || message.isEmpty ? 'Something went wrong.' : message,
      );
    });
  }

  RoomModel? _parseRoom(dynamic response) {
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

    try {
      return RoomModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // MOVE PARSING
  // ===========================================================================

  _MoveResult? _parseMove(dynamic response) {
    if (response is! Map || response['success'] != true) {
      return null;
    }

    final data = response['data'];

    if (data is! Map) {
      return null;
    }

    final roomData = data['room'];
    final moveData = data['move'];

    if (roomData is! Map || moveData is! Map) {
      return null;
    }

    final index = moveData['index'];
    final symbolValue = moveData['symbol'];

    if (index is! int || symbolValue is! String) {
      return null;
    }

    try {
      final room = RoomModel.fromJson(Map<String, dynamic>.from(roomData));

      final symbol = PlayerSymbol.fromValue(symbolValue);

      return _MoveResult(room: room, index: index, symbol: symbol);
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // ROUND RESULT PARSING
  // ===========================================================================

  _RoundResult? _parseRoundResult(dynamic response) {
    if (response is! Map || response['success'] != true) {
      return null;
    }

    final data = response['data'];

    if (data is! Map) {
      return null;
    }

    final roomData = data['room'];
    final winnerSocketId = data['winnerSocketId'];
    final winningIndexesData = data['winningIndexes'];
    final completedRound = data['completedRound'];
    final gameFinished = data['gameFinished'];

    if (roomData is! Map ||
        winnerSocketId is! String ||
        winningIndexesData is! List ||
        completedRound is! int ||
        gameFinished is! bool) {
      return null;
    }

    try {
      final room = RoomModel.fromJson(Map<String, dynamic>.from(roomData));

      return _RoundResult(
        room: room,
        winnerSocketId: winnerSocketId,
        winningIndexes: winningIndexesData.whereType<int>().toList(),
        completedRound: completedRound,
        gameFinished: gameFinished,
      );
    } catch (_) {
      return null;
    }
  }
}

// =============================================================================
// INTERNAL RESULT TYPES
// =============================================================================

class _MoveResult {
  const _MoveResult({
    required this.room,
    required this.index,
    required this.symbol,
  });

  final RoomModel room;
  final int index;
  final PlayerSymbol symbol;
}

class _RoundResult {
  const _RoundResult({
    required this.room,
    required this.winnerSocketId,
    required this.winningIndexes,
    required this.completedRound,
    required this.gameFinished,
  });

  final RoomModel room;
  final String winnerSocketId;
  final List<int> winningIndexes;
  final int completedRound;
  final bool gameFinished;
}
