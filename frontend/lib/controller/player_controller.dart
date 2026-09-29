import 'package:tictac_duel/lib.dart';

class PlayerController extends GetxController {
  PlayerController({required this._storage, required this._playerApiService});

  final LocalStorageService _storage;
  final PlayerApiService _playerApiService;

  static const String _playerIdKey = 'player_id';

  final RxnString _playerId = RxnString();

  String get playerId {
    final id = _playerId.value;

    if (id == null || id.isEmpty) {
      throw StateError('Player ID is not initialized');
    }

    return id;
  }

  bool get isInitialized => _playerId.value?.isNotEmpty ?? false;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      var playerId = await _storage.getString(_playerIdKey);

      if (playerId == null || playerId.isEmpty) {
        final user = await _playerApiService.create();

        playerId = user.id;

        await _storage.setString(_playerIdKey, playerId);
      }

      _playerId.value = playerId;
    } catch (error, stackTrace) {
      LoggerUtils.error('PlayerController._initialize', error, stackTrace);
    }
  }
}
