import 'package:tictac_duel/lib.dart';

class RoomSocketService {
  RoomSocketService._();

  static final RoomSocketService instance = RoomSocketService._();

  final SocketService _socket = SocketService.instance;

  // ---------------------------------------------------------------------------
  // Requests
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // Room Events
  // ---------------------------------------------------------------------------

  void onRoomCreated(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.roomCreated, callback);
  }

  void onRoomJoined(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.roomJoined, callback);
  }

  void onRoomUpdated(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.roomUpdated, callback);
  }

  // ---------------------------------------------------------------------------
  // Player Events
  // ---------------------------------------------------------------------------

  void onPlayerJoined(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.playerJoined, callback);
  }

  void onPlayerLeft(void Function(RoomModel room) callback) {
    _listenToRoomEvent(RoomSocketEvents.playerLeft, callback);
  }

  // void onReadyUpdated(void Function(RoomModel room) callback) {
  //   _listenToRoomEvent(RoomSocketEvents.readyUpdated, callback);
  // }

  // ---------------------------------------------------------------------------
  // Error Events
  // ---------------------------------------------------------------------------

  void onRoomError(void Function(String message) callback) {
    _listenToMessageEvent(RoomSocketEvents.roomError, callback);
  }

  void onGameError(void Function(String message) callback) {
    _listenToMessageEvent(RoomSocketEvents.gameError, callback);
  }

  // ---------------------------------------------------------------------------
  // Game Requests
  // ---------------------------------------------------------------------------

  void makeMove({required String roomCode, required int index}) {
    _socket.emit(RoomSocketEvents.makeMove, {
      'roomCode': roomCode,
      'index': index,
    });
  }

  void submitGameResult({
    required String roomCode,
    required String winnerSocketId,
    required List<int> winningIndexes,
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

  // ---------------------------------------------------------------------------
  // Game Events
  // ---------------------------------------------------------------------------

  void onMoveMade(
    void Function({
      required RoomModel room,
      required int index,
      required PlayerSymbol symbol,
    })
    callback,
  ) {
    _socket.off(RoomSocketEvents.moveMade);
    _socket.on(RoomSocketEvents.moveMade, (response) {
      if (response is! Map) {
        return;
      }
      if (response['success'] != true) {
        return;
      }
      final data = response['data'];
      if (data is! Map) {
        return;
      }
      final roomData = data['room'];
      final moveData = data['move'];
      if (roomData is! Map || moveData is! Map) {
        return;
      }
      final room = RoomModel.fromJson(Map<String, dynamic>.from(roomData));
      final index = moveData['index'];
      final symbolValue = moveData['symbol'];
      if (index is! int || symbolValue is! String) {
        return;
      }
      try {
        final symbol = PlayerSymbol.fromValue(symbolValue);
        callback(room: room, index: index, symbol: symbol);
      } catch (_) {
        return;
      }
    });
  }

  void onReadyUpdated(void Function(RoomModel room) callback) {
    _socket.off(RoomSocketEvents.readyUpdated);

    _socket.on(RoomSocketEvents.readyUpdated, (response) {
      final room = _parseRoom(response);

      if (room == null) {
        return;
      }

      callback(room);
    });
  }

  void onGameStarted(void Function(RoomModel room) callback) =>
      _listenToRoomEvent(RoomSocketEvents.gameStarted, callback);

  void onGameEnded(void Function(RoomModel room) callback) =>
      _listenToRoomEvent(RoomSocketEvents.gameEnded, callback);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _listenToRoomEvent(
    String event,
    void Function(RoomModel room) callback,
  ) {
    _socket.off(event);

    _socket.on(event, (response) {
      final room = _parseRoom(response);

      if (room != null) {
        callback(room);
      }
    });
  }

  void _listenToMessageEvent(
    String event,
    void Function(String message) callback,
  ) {
    _socket.off(event);

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

  // ---------------------------------------------------------------------------
  // Round Result Event
  // ---------------------------------------------------------------------------

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
    _socket.off(RoomSocketEvents.roundResult);

    _socket.on(RoomSocketEvents.roundResult, (response) {
      if (response is! Map) {
        return;
      }

      if (response['success'] != true) {
        return;
      }

      final data = response['data'];

      if (data is! Map) {
        return;
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
        return;
      }

      try {
        final room = RoomModel.fromJson(Map<String, dynamic>.from(roomData));

        final winningIndexes = winningIndexesData.whereType<int>().toList();

        callback(
          room: room,
          winnerSocketId: winnerSocketId,
          winningIndexes: winningIndexes,
          completedRound: completedRound,
          gameFinished: gameFinished,
        );
      } catch (_) {
        return;
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  void dispose() {
    _socket.off(RoomSocketEvents.roomCreated);
    _socket.off(RoomSocketEvents.roomJoined);
    _socket.off(RoomSocketEvents.roomUpdated);

    _socket.off(RoomSocketEvents.playerJoined);
    _socket.off(RoomSocketEvents.playerLeft);

    _socket.off(RoomSocketEvents.roomError);

    _socket.off(RoomSocketEvents.makeMove);
    _socket.off(RoomSocketEvents.moveMade);

    _socket.off(RoomSocketEvents.gameStarted);
    _socket.off(RoomSocketEvents.gameEnded);
    _socket.off(RoomSocketEvents.gameError);
  }
}
