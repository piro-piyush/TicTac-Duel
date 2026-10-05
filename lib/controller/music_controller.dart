import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class MusicController extends GetxController {
  MusicController({
    required this._backgroundPlayer,
    required this._touchPlayer,
    required this._effectPlayer,
    required this._storage,
  });

  final AudioPlayer _backgroundPlayer;
  final AudioPlayer _touchPlayer;
  final AudioPlayer _effectPlayer;
  final LocalStorageService _storage;

  static const String _musicEnabledKey = 'background_music_enabled';
  static const String _effectsEnabledKey = 'sound_effects_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';

  static const String _logName = 'MusicController';

  final RxBool _isEnabled = true.obs;
  final RxBool _effectsEnabled = true.obs;
  final RxBool _vibrationEnabled = true.obs;
  final RxBool _isInitialized = false.obs;

  // Web browsers require a user interaction before audio can start.
  bool get isWeb => kIsWeb;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  bool get isEnabled => _isEnabled.value;

  bool get effectsEnabled => _effectsEnabled.value;

  bool get vibrationEnabled => _vibrationEnabled.value;

  bool get isInitialized => _isInitialized.value;

  bool get isPlaying => isInitialized && _backgroundPlayer.playing;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();
    unawaited(_init());
  }

  Future<void> _init() async {
    if (_isInitialized.value) {
      return;
    }

    try {
      _isEnabled.value = await _storage.getBool(_musicEnabledKey) ?? true;

      _effectsEnabled.value =
          await _storage.getBool(_effectsEnabledKey) ?? true;

      _vibrationEnabled.value =
          await _storage.getBool(_vibrationEnabledKey) ?? true;

      // -----------------------------------------------------------------------
      // Background music
      // -----------------------------------------------------------------------

      await _backgroundPlayer.setAsset(AudioConstants.backgroundMusic);

      await _backgroundPlayer.setLoopMode(LoopMode.one);
      await _backgroundPlayer.setVolume(0.3);

      // -----------------------------------------------------------------------
      // Touch sound
      // -----------------------------------------------------------------------

      await _touchPlayer.setAsset(AudioConstants.touchSound);

      await _touchPlayer.setVolume(1.0);

      // -----------------------------------------------------------------------
      // Game sound effects
      // -----------------------------------------------------------------------

      await _effectPlayer.setVolume(1.0);

      _isInitialized.value = true;

      // Browsers require user interaction before audio playback.
      if (_isEnabled.value && !isWeb) {
        unawaited(play());
      }
    } catch (e, st) {
      await _disposePlayers();

      dev.log(
        'Failed to initialize music controller',
        name: _logName,
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // BACKGROUND MUSIC
  // ===========================================================================

  Future<void> play() async {
    if (!isInitialized || !_isEnabled.value || _backgroundPlayer.playing) {
      return;
    }

    try {
      await _backgroundPlayer.play();
    } catch (e, st) {
      dev.log('Failed to play music', name: _logName, error: e, stackTrace: st);
    }
  }

  Future<void> pause() async {
    if (!isInitialized || !_backgroundPlayer.playing) {
      return;
    }

    try {
      await _backgroundPlayer.pause();
    } catch (e, st) {
      dev.log(
        'Failed to pause music',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> stop() async {
    if (!isInitialized) {
      return;
    }

    try {
      await _backgroundPlayer.stop();
    } catch (e, st) {
      dev.log('Failed to stop music', name: _logName, error: e, stackTrace: st);
    }
  }

  Future<void> resume() async {
    if (!isInitialized || !_isEnabled.value) {
      return;
    }

    try {
      await _backgroundPlayer.play();
    } catch (e, st) {
      dev.log(
        'Failed to resume music',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  // ===========================================================================
  // TOUCH SOUND
  // ===========================================================================

  void playTouch() {
    if (!isInitialized) {
      return;
    }

    // On Web, the first touch also unlocks background audio.
    if (_isEnabled.value && isWeb && !_backgroundPlayer.playing) {
      unawaited(play());
    }

    if (_effectsEnabled.value) {
      unawaited(_playTouchSound());
    }

    if (_vibrationEnabled.value) {
      unawaited(HapticFeedback.selectionClick());
    }
  }

  Future<void> _playTouchSound() async {
    try {
      await _touchPlayer.seek(Duration.zero);
      await _touchPlayer.play();
    } catch (e, st) {
      dev.log(
        'Failed to play touch sound',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  // ===========================================================================
  // SOUND EFFECTS
  // ===========================================================================

  void playConfetti() {
    _playEffect(AudioConstants.confettiSound);
  }

  void playWin() {
    _playEffect(AudioConstants.winSound);
  }

  void playLose() {
    _playEffect(AudioConstants.loseSound);
  }

  void playSwoosh() {
    _playEffect(AudioConstants.swooshSound);
  }

  void playRoundStart() {
    if (!isInitialized) {
      return;
    }

    if (_effectsEnabled.value) {
      unawaited(_playEffect(AudioConstants.roundSound));
    }

    if (_vibrationEnabled.value) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  void playJoin() {
    if (!isInitialized) {
      return;
    }

    if (_effectsEnabled.value) {
      unawaited(_playEffect(AudioConstants.joinSound));
    }

    if (_vibrationEnabled.value) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  // ===========================================================================
  // EFFECT PLAYBACK
  // ===========================================================================

  Future<void> _playEffect(String asset) async {
    if (!isInitialized || !_effectsEnabled.value) {
      return;
    }

    try {
      await _effectPlayer.stop();
      await _effectPlayer.setAsset(asset);
      await _effectPlayer.seek(Duration.zero);
      await _effectPlayer.play();
    } catch (e, st) {
      dev.log(
        'Failed to play sound effect: $asset',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  // ===========================================================================
  // MUSIC SETTINGS
  // ===========================================================================

  Future<void> setEnabled(bool enabled) async {
    if (!isInitialized) {
      return;
    }

    if (_isEnabled.value == enabled) {
      return;
    }

    try {
      _isEnabled.value = enabled;

      await _storage.setBool(_musicEnabledKey, enabled);

      if (enabled) {
        await play();
      } else {
        await pause();
      }
    } catch (e, st) {
      dev.log(
        'Failed to update music setting: $enabled',
        name: _logName,
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // SOUND EFFECT SETTINGS
  // ===========================================================================

  Future<void> setEffectsEnabled(bool enabled) async {
    if (!isInitialized) {
      return;
    }

    if (_effectsEnabled.value == enabled) {
      return;
    }

    try {
      _effectsEnabled.value = enabled;

      await _storage.setBool(_effectsEnabledKey, enabled);

      if (!enabled) {
        await Future.wait([_touchPlayer.stop(), _effectPlayer.stop()]);
      }
    } catch (e, st) {
      dev.log(
        'Failed to update sound effects setting: $enabled',
        name: _logName,
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // VIBRATION / HAPTIC FEEDBACK
  // ===========================================================================

  Future<void> setVibrationEnabled(bool enabled) async {
    if (!isInitialized) {
      return;
    }

    if (_vibrationEnabled.value == enabled) {
      return;
    }

    try {
      _vibrationEnabled.value = enabled;

      await _storage.setBool(_vibrationEnabledKey, enabled);
    } catch (e, st) {
      dev.log(
        'Failed to update vibration setting: $enabled',
        name: _logName,
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  Future<void> lightVibration() async {
    if (!_vibrationEnabled.value) {
      return;
    }

    try {
      await HapticFeedback.lightImpact();
    } catch (e, st) {
      dev.log(
        'Failed to trigger light vibration',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> mediumVibration() async {
    if (!_vibrationEnabled.value) {
      return;
    }

    try {
      await HapticFeedback.mediumImpact();
    } catch (e, st) {
      dev.log(
        'Failed to trigger medium vibration',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> heavyVibration() async {
    if (!_vibrationEnabled.value) {
      return;
    }

    try {
      await HapticFeedback.heavyImpact();
    } catch (e, st) {
      dev.log(
        'Failed to trigger heavy vibration',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  // ===========================================================================
  // VOLUME
  // ===========================================================================

  Future<void> setVolume(double volume) async {
    if (!isInitialized) {
      return;
    }

    final clampedVolume = volume.clamp(0.0, 1.0).toDouble();

    try {
      await Future.wait([
        _backgroundPlayer.setVolume(clampedVolume * 0.4),
        _touchPlayer.setVolume(clampedVolume),
        _effectPlayer.setVolume(clampedVolume),
      ]);
    } catch (e, st) {
      dev.log(
        'Failed to set audio volume',
        name: _logName,
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void onClose() {
    unawaited(_disposePlayers());
    super.onClose();
  }

  Future<void> _disposePlayers() async {
    if (!_isInitialized.value) {
      return;
    }

    _isInitialized.value = false;

    try {
      await Future.wait([
        _backgroundPlayer.dispose(),
        _touchPlayer.dispose(),
        _effectPlayer.dispose(),
      ]);
    } catch (e, st) {
      dev.log(
        'Failed to dispose audio players',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }
}
