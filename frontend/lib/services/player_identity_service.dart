import 'package:tictac_duel/lib.dart';

class PlayerIdentityService {
  PlayerIdentityService({required this._storage});

  final LocalStorageService _storage;

  static const _playerIdKey = 'player_id';

  String generatePlayerId() => const Uuid().v4();

  Future<String?>? getPlayerId() {
    try {
      return _storage.getString(_playerIdKey);
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to get player ID', error, stackTrace);
      return null;
    }
  }

  Future<bool> setPlayerId(String playerId) async {
    try {
      return await _storage.setString(_playerIdKey, playerId);
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to save player ID', error, stackTrace);
      return false;
    }
  }

  Future<bool> clearPlayerId() async {
    try {
      return await _storage.remove(_playerIdKey);
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to clear player ID', error, stackTrace);
      return false;
    }
  }
}
