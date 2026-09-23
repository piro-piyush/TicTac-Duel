import 'package:tictac_duel/lib.dart';

class RoomDataProvider extends ChangeNotifier {
  RoomModel? _room;

  RoomModel? get room => _room;

  bool get hasRoom => _room != null;

  void setRoom(RoomModel room) {
    _room = room;
    notifyListeners();
  }

  void clearRoom() {
    if (_room == null) {
      return;
    }

    _room = null;
    notifyListeners();
  }
}
