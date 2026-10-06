import 'package:tictac_duel/lib.dart';

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);

class PlayerNotifier extends Notifier<PlayerState> {
  static const String _playerIdKey = 'player_id';

  late final LocalStorageService _storage;
  late final PlayerApiService _playerApiService;

  @override
  PlayerState build() {
    _storage = ref.read(localStorageServiceProvider);
    _playerApiService = ref.read(playerApiServiceProvider);

    return const PlayerState();
  }

  String get playerId {
    final id = state.playerId;

    if (id == null || id.isEmpty) {
      throw StateError('Player ID is not initialized');
    }

    return id;
  }

  bool get isInitialized => state.isInitialized;

  Future<void> initialize() async {
    if (state.isInitialized) {
      return;
    }

    try {
      var playerId = await _storage.getString(_playerIdKey);

      if (playerId == null || playerId.isEmpty) {
        final user = await _playerApiService.create();

        playerId = user.id;

        await _storage.setString(_playerIdKey, playerId);
      }

      state = state.copyWith(playerId: playerId, isInitialized: true);
    } catch (error, stackTrace) {
      LoggerUtils.error('PlayerNotifier.initialize', error, stackTrace);

      rethrow;
    }
  }
}
