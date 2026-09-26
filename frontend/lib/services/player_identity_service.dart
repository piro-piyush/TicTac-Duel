import 'package:tictac_duel/lib.dart';

class PlayerIdentityService {
  PlayerIdentityService(this._preferences);

  final SharedPreferences _preferences;

  static const _playerIdKey = 'player_id';

  String? get localPlayerId {
    final playerId = _preferences.getString(_playerIdKey);

    if (playerId == null || playerId.isEmpty) {
      return null;
    }

    return playerId;
  }

  Future<String> createPlayerId() async {
    final playerId = const Uuid().v4();

    await _preferences.setString(_playerIdKey, playerId);

    return playerId;
  }


}
