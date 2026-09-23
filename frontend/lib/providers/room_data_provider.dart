import 'package:tictac_duel/lib.dart';

class RoomDataProvider extends ChangeNotifier {
  RoomModel? _room;

  final List<PlayerSymbol?> _board = List<PlayerSymbol?>.filled(9, null);

  RoomModel? get room => _room;

  bool get hasRoom => _room != null;

  List<PlayerSymbol?> get board => List.unmodifiable(_board);

  void setRoom(RoomModel room) {
    _room = room;
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

  PlayerSymbol? getBoardValue(int index, ) {
    if (index < 0 || index >= _board.length) {
      return null;
    }
    return _board[index];
  }

  void clearBoard() {
    for (var i = 0; i < _board.length; i++) {
      _board[i] = null;
    }

    notifyListeners();
  }

  void clearRoom() {
    if (_room == null) {
      return;
    }

    _room = null;
    clearBoard();
  }
}
