import 'package:tictac_duel/lib.dart';

class MusicProvider extends ChangeNotifier {
  MusicProvider(this._musicService);

  final MusicService _musicService;

  bool _isInitialized = false;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  bool get isInitialized => _isInitialized;

  bool get isEnabled => _musicService.isEnabled;

  bool get effectsEnabled => _musicService.effectsEnabled;

  bool get vibrationEnabled => _musicService.vibrationEnabled;

  bool get isPlaying => _musicService.isPlaying;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    await _musicService.init();

    _isInitialized = true;
    notifyListeners();
  }

  // ===========================================================================
  // MUSIC
  // ===========================================================================

  Future<void> setMusicEnabled(bool enabled) async {
    await _musicService.setEnabled(enabled);
    notifyListeners();
  }

  Future<void> playMusic() async {
    await _musicService.play();
    notifyListeners();
  }

  Future<void> pauseMusic() async {
    await _musicService.pause();
    notifyListeners();
  }

  // ===========================================================================
  // SOUND EFFECTS
  // ===========================================================================

  Future<void> setEffectsEnabled(bool enabled) async {
    await _musicService.setEffectsEnabled(enabled);
    notifyListeners();
  }

  void playTouch() {
    _musicService.playTouch();
  }

  void playConfetti() {
    _musicService.playConfetti();
  }

  void playWin() {
    _musicService.playWin();
  }

  void playLose() {
    _musicService.playLose();
  }

  void playRoundStart() {
    _musicService.playRoundStart();
  }

  void playJoin() {
    _musicService.playJoin();
  }

  // ===========================================================================
  // VIBRATION / HAPTICS
  // ===========================================================================

  Future<void> setVibrationEnabled(bool enabled) async {
    await _musicService.setVibrationEnabled(enabled);
    notifyListeners();
  }

  Future<void> vibrate() {
    return _musicService.lightVibration();
  }

  Future<void> lightVibration() {
    return _musicService.lightVibration();
  }

  Future<void> mediumVibration() {
    return _musicService.mediumVibration();
  }

  Future<void> heavyVibration() {
    return _musicService.heavyVibration();
  }

  // Future<void> selectionVibration() {
  //   return _musicService.selectionVibration();
  // }

  // ===========================================================================
  // VOLUME
  // ===========================================================================

  Future<void> setVolume(double volume) async {
    await _musicService.setVolume(volume);
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _musicService.dispose();
    super.dispose();
  }
}
