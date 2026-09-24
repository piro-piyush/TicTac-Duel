import 'package:tictac_duel/lib.dart';

class RoomDataProvider extends ChangeNotifier {
  RoomModel? _room;

  List<PlayerSymbol?> _board = List<PlayerSymbol?>.empty();

  Set<int> _winningIndexes = {};

  RoomModel? get room => _room;

  bool get hasRoom => _room != null;

  List<PlayerSymbol?> get board => List.unmodifiable(_board);

  Set<int> get winningIndexes => Set.unmodifiable(_winningIndexes);

  void setRoom(RoomModel room) {
    _room = room;
    _board = List<PlayerSymbol?>.filled(room.boardSize, null);
    _winningIndexes = {};
    notifyListeners();
  }

  void updateRoom(RoomModel room) {
    _room = room;
    notifyListeners();
  }

  void setBoardValue(int index, PlayerSymbol symbol) {
    if (index < 0 || index >= _board.length) {
      return;
    }

    if (_board[index] != null) {
      return;
    }

    _board[index] = symbol;
    notifyListeners();
  }

  PlayerSymbol? getBoardValue(int index) {
    if (index < 0 || index >= _board.length) {
      return null;
    }

    return _board[index];
  }

  void setWinningIndexes(Set<int> indexes) {
    _winningIndexes = Set.from(indexes);
    notifyListeners();
  }

  void clearBoard() {
    _board = List<PlayerSymbol?>.filled(_room?.boardSize ?? 0, null);

    _winningIndexes = {};
    notifyListeners();
  }

  void clearRoom() {
    if (_room == null) {
      return;
    }

    _room = null;
    _board = List<PlayerSymbol?>.empty();
    _winningIndexes = {};

    notifyListeners();
  }
}
