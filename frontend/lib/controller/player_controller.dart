import 'package:tictac_duel/lib.dart';

class PlayerController extends GetxController {
  PlayerController({
    required this._identityService,
    required this._playerApiService,
  });

  final PlayerIdentityService _identityService;
  final PlayerApiService _playerApiService;

  final RxnString _playerId = RxnString();

  String get playerId {
    final id = _playerId.value;

    if (id == null || id.isEmpty) {
      throw StateError('Player ID is not initialized');
    }

    return id;
  }

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      var playerId = await _identityService.getPlayerId();

      if (playerId == null) {
        final player = await _playerApiService.create();

        playerId = player.id;

        await _identityService.setPlayerId(playerId);
      }

      _playerId.value = playerId;
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to initialize player', error, stackTrace);
    }
  }
}
