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
    required void Function(RoomModel room) onConnected,
  }) async {
    _socket.on(
      RoomSocketEvents.roomConnected,
          (response) {
        final room = _parseRoom(response);

        if (room == null) return;

        onConnected(room);
      },
    );

    await _socket.connect();

    connectRoom(
      roomCode: roomCode,
      playerId: playerId,
    );
  }

  void disconnect() {
    _socket.disconnect();
  }

  // ===========================================================================
  // ROOM REQUESTS
  // ===========================================================================

  void connectRoom({required String roomCode, required String playerId}) {
    _socket.emit(RoomSocketEvents.connectRoom, {
      'roomCode': roomCode,
      'playerId': playerId,
    });
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

  void toggleReady({required String roomCode, required bool isReady}) {
    _socket.emit(RoomSocketEvents.toggleReady, {
      'roomCode': roomCode,
      'isReady': isReady,
    });
  }

  // ===========================================================================
  // ROOM EVENTS
  // ===========================================================================

  // void onRoomConnected(void Function(RoomModel room) callback) {
  //   _onRoomEvent(RoomSocketEvents.roomConnected, callback);
  // }

  // ===========================================================================
  // READY EVENTS
  // ===========================================================================

  void onReadyUpdated(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.readyUpdated, callback);
  }



  void onPlayerJoined(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.playerJoined, callback);
  }

  void onPlayerLeft(void Function(RoomModel room) callback) {
    _onRoomEvent(RoomSocketEvents.playerLeft, callback);
  }




  // ===========================================================================
  // MOVE EVENTS
  // ===========================================================================

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

  // ===========================================================================
  // ROUND RESULT EVENTS
  // ===========================================================================

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

  // ===========================================================================
  // LISTENER MANAGEMENT
  // ===========================================================================

  void off(String event) {
    _socket.off(event);
  }

  // void offRoomConnected() {
  //   off(RoomSocketEvents.roomConnected);
  // }

  void offReadyUpdated() {
    off(RoomSocketEvents.readyUpdated);
  }

  void offMoveMade() {
    off(RoomSocketEvents.moveMade);
  }

  void offRoundResult() {
    off(RoomSocketEvents.roundResult);
  }

  void offRoomError() {
    off(RoomSocketEvents.roomError);
  }

  void dispose() {
    _socket.dispose();
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
        callback(SocketConstants.genericErrorMessage);
        return;
      }

      final message = response['message']?.toString();

      callback(
        message == null || message.isEmpty
            ? SocketConstants.genericErrorMessage
            : message,
      );
    });
  }

  RoomModel? _parseRoom(dynamic response) {
    if (response is! Map || response['success'] != true) {
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
