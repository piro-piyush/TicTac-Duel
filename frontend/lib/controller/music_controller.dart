import 'dart:developer' as dev;

import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class MusicController extends GetxController {
  MusicController({required this._player, required this._effectPlayer});

  final AudioPlayer _player;
  final AudioPlayer _effectPlayer;

  static const String _musicEnabledKey = 'background_music_enabled';
  static const String _effectsEnabledKey = 'sound_effects_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';

  static const String _logName = 'MusicController';

  final RxBool _isEnabled = true.obs;
  final RxBool _effectsEnabled = true.obs;
  final RxBool _vibrationEnabled = true.obs;
  final RxBool _isInitialized = false.obs;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  bool get isEnabled => _isEnabled.value;

  bool get effectsEnabled => _effectsEnabled.value;

  bool get vibrationEnabled => _vibrationEnabled.value;

  bool get isInitialized => _isInitialized.value;

  bool get isPlaying => isInitialized && _player.playing;

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

    final prefs = Get.find<SharedPreferences>();

    try {
      _isEnabled.value = prefs.getBool(_musicEnabledKey) ?? true;

      _effectsEnabled.value = prefs.getBool(_effectsEnabledKey) ?? true;

      _vibrationEnabled.value = prefs.getBool(_vibrationEnabledKey) ?? true;

      // -----------------------------------------------------------------------
      // Background music
      // -----------------------------------------------------------------------

      await _player.setAsset(AudioConstants.backgroundMusic);

      await _player.setLoopMode(LoopMode.one);

      await _player.setVolume(0.4);

      // -----------------------------------------------------------------------
      // Sound effects
      // -----------------------------------------------------------------------

      await _effectPlayer.setVolume(1.0);

      _isInitialized.value = true;

      if (_isEnabled.value) {
        unawaited(play());
      }
    } catch (e, st) {
      await _player.dispose();
      await _effectPlayer.dispose();

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
    if (!isInitialized || !_isEnabled.value || _player.playing) {
      return;
    }

    try {
      await _player.play();
    } catch (e, st) {
      dev.log('Failed to play music', name: _logName, error: e, stackTrace: st);
    }
  }

  Future<void> pause() async {
    if (!isInitialized || !_player.playing) {
      return;
    }

    try {
      await _player.pause();
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
      await _player.stop();
    } catch (e, st) {
      dev.log('Failed to stop music', name: _logName, error: e, stackTrace: st);
    }
  }

  Future<void> resume() async {
    if (!isInitialized || !_isEnabled.value) {
      return;
    }

    try {
      await _player.play();
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
  // SOUND EFFECTS
  // ===========================================================================

  void playTouch() {
    if (!isInitialized) {
      return;
    }

    if (_effectsEnabled.value) {
      unawaited(_playEffect(AudioConstants.touchSound));
    }

    if (_vibrationEnabled.value) {
      unawaited(HapticFeedback.selectionClick());
    }
  }

  void playConfetti() {
    if (!isInitialized || !_effectsEnabled.value) {
      return;
    }

    unawaited(_playEffect(AudioConstants.confettiSound));
  }

  void playWin() {
    if (!isInitialized || !_effectsEnabled.value) {
      return;
    }

    unawaited(_playEffect(AudioConstants.winSound));
  }

  void playLose() {
    if (!isInitialized || !_effectsEnabled.value) {
      return;
    }

    unawaited(_playEffect(AudioConstants.loseSound));
  }

  void playRoundStart() {
    if (!isInitialized || !_effectsEnabled.value) {
      return;
    }

    unawaited(_playEffect(AudioConstants.roundSound));

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

    final prefs = Get.find<SharedPreferences>();

    try {
      _isEnabled.value = enabled;

      await prefs.setBool(_musicEnabledKey, enabled);

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

    final prefs = Get.find<SharedPreferences>();

    try {
      _effectsEnabled.value = enabled;

      await prefs.setBool(_effectsEnabledKey, enabled);
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

    final prefs = Get.find<SharedPreferences>();

    try {
      _vibrationEnabled.value = enabled;

      await prefs.setBool(_vibrationEnabledKey, enabled);
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

    await HapticFeedback.lightImpact();
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

    await HapticFeedback.heavyImpact();
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
        _player.setVolume(clampedVolume * 0.4),
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

    try {
      await Future.wait([_player.dispose(), _effectPlayer.dispose()]);
    } finally {
      _isInitialized.value = false;
    }
  }
}
