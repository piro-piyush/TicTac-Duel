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
    try {
      _isLoading.value = true;
      _error.value = null;
      _isInitialized.value = false;

      final existingPlayerId = _identityService.localPlayerId;

      if (existingPlayerId != null) {
        _playerId.value = existingPlayerId;
        _isInitialized.value = true;
        return;
      }

      final playerId = await _identityService.createPlayerId();

      _playerId.value = playerId;

      await _playerApiService.initialize(playerId);

      _isInitialized.value = true;
    } catch (error) {
      _error.value = error.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> retry() async => await initialize();
}
