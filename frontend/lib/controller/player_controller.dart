import 'package:tictac_duel/lib.dart';

class PlayerController extends GetxController {
  PlayerController({
    required this._identityService,
    required this._playerApiService,
  });

  final PlayerIdentityService _identityService;
  final PlayerApiService _playerApiService;

  final RxString _playerId = ''.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isInitialized = false.obs;
  final RxnString _error = RxnString();

  String get playerId => _playerId.value;

  bool get isLoading => _isLoading.value;

  bool get isInitialized => _isInitialized.value;

  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    _isLoading.value = true;
    _isInitialized.value = false;
    _error.value = null;

    try {
      var playerId = await _identityService.getPlayerId();

      if (playerId == null) {
        playerId = _identityService.generatePlayerId();

        await _playerApiService.initialize(playerId);

        final saved = await _identityService.setPlayerId(playerId);

        if (!saved) {
          throw Exception('Failed to save player identity');
        }
      } else {
        await _playerApiService.initialize(playerId);
      }

      _playerId.value = playerId;
      _isInitialized.value = true;
    } catch (error, stackTrace) {
      _error.value = error.toString();

      LoggerUtils.error('Failed to initialize player', error, stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

}
