import 'package:tictac_duel/lib.dart';

class MusicNotifier extends Notifier<MusicState> {
  late final MusicService _musicService;

  @override
  MusicState build() {
    _musicService = ref.watch(musicServiceProvider);

    ref.onDispose(_musicService.dispose);

    return MusicState(
      isEnabled: _musicService.isEnabled,
      effectsEnabled: _musicService.effectsEnabled,
      vibrationEnabled: _musicService.vibrationEnabled,
      isPlaying: _musicService.isPlaying,
    );
  }

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  Future<void> init() async {
    if (state.isInitialized) {
      return;
    }

    await _musicService.init();

    state = state.copyWith(
      isInitialized: true,
      isEnabled: _musicService.isEnabled,
      effectsEnabled: _musicService.effectsEnabled,
      vibrationEnabled: _musicService.vibrationEnabled,
      isPlaying: _musicService.isPlaying,
    );
  }

  // ===========================================================================
  // MUSIC
  // ===========================================================================

  Future<void> setMusicEnabled(bool enabled) async {
    await _musicService.setEnabled(enabled);

    state = state.copyWith(
      isEnabled: _musicService.isEnabled,
      isPlaying: _musicService.isPlaying,
    );
  }

  Future<void> playMusic() async {
    await _musicService.play();

    state = state.copyWith(isPlaying: _musicService.isPlaying);
  }

  Future<void> pauseMusic() async {
    await _musicService.pause();

    state = state.copyWith(isPlaying: _musicService.isPlaying);
  }

  // ===========================================================================
  // SOUND EFFECTS
  // ===========================================================================

  Future<void> setEffectsEnabled(bool enabled) async {
    await _musicService.setEffectsEnabled(enabled);

    state = state.copyWith(effectsEnabled: _musicService.effectsEnabled);
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

    state = state.copyWith(vibrationEnabled: _musicService.vibrationEnabled);
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
}

final musicProvider = NotifierProvider<MusicNotifier, MusicState>(
  MusicNotifier.new,
);
