import 'dart:developer' as dev;

import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class MusicService {
  MusicService(this._prefs);

  final SharedPreferences _prefs;

  late final AudioPlayer _player;
  late final AudioPlayer _effectPlayer;

  static const String _musicEnabledKey = 'background_music_enabled';

  static const String _effectsEnabledKey = 'sound_effects_enabled';

  static const String _vibrationEnabledKey = 'vibration_enabled';

  static const String _logName = 'MusicService';

  bool _isEnabled = true;
  bool _effectsEnabled = true;
  bool _vibrationEnabled = true;
  bool _initialized = false;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  bool get isEnabled => _isEnabled;

  bool get effectsEnabled => _effectsEnabled;

  bool get vibrationEnabled => _vibrationEnabled;

  bool get isInitialized => _initialized;

  bool get isPlaying => _initialized && _player.playing;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    final player = AudioPlayer();
    final effectPlayer = AudioPlayer();

    try {
      _isEnabled = _prefs.getBool(_musicEnabledKey) ?? true;

      _effectsEnabled = _prefs.getBool(_effectsEnabledKey) ?? true;

      _vibrationEnabled = _prefs.getBool(_vibrationEnabledKey) ?? true;

      // -----------------------------------------------------------------------
      // Background music
      // -----------------------------------------------------------------------

      await player.setAsset(AudioConstants.backgroundMusic);

      await player.setLoopMode(LoopMode.one);
      await player.setVolume(0.4);

      // -----------------------------------------------------------------------
      // Sound effects
      // -----------------------------------------------------------------------

      await effectPlayer.setVolume(1.0);

      _player = player;
      _effectPlayer = effectPlayer;
      _initialized = true;

      if (_isEnabled) {
        unawaited(play());
      }
    } catch (e, st) {
      player.dispose();
      effectPlayer.dispose();

      dev.log(
        'Failed to initialize music service',
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
    if (!_initialized || !_isEnabled || _player.playing) {
      return;
    }

    try {
      await _player.play();
    } catch (e, st) {
      dev.log('Failed to play music', name: _logName, error: e, stackTrace: st);
    }
  }

  Future<void> pause() async {
    if (!_initialized || !_player.playing) {
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
    if (!_initialized) {
      return;
    }

    try {
      await _player.stop();
    } catch (e, st) {
      dev.log('Failed to stop music', name: _logName, error: e, stackTrace: st);
    }
  }

  Future<void> resume() async {
    if (!_initialized || !_isEnabled) {
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
    if (!_initialized) {
      return;
    }

    if (_effectsEnabled) {
      unawaited(
        _playEffect(AudioConstants.touchSound),
      );
    }

    if (_vibrationEnabled) {
      unawaited(
        HapticFeedback.selectionClick(),
      );
    }
  }

  void playConfetti() {
    if (!_initialized || !_effectsEnabled) {
      return;
    }

    unawaited(_playEffect(AudioConstants.confettiSound));
  }

  void playWin() {
    if (!_initialized || !_effectsEnabled) {
      return;
    }

    unawaited(_playEffect(AudioConstants.winSound));
  }

  void playLose() {
    if (!_initialized || !_effectsEnabled) {
      return;
    }

    unawaited(_playEffect(AudioConstants.loseSound));
  }

  void playJoin() {
    if (!_initialized || !_effectsEnabled) {
      return;
    }

    unawaited(_playEffect(AudioConstants.joinSound));
  }

  Future<void> _playEffect(String asset) async {
    if (!_initialized || !_effectsEnabled) {
      return;
    }

    try {
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
    if (!_initialized) {
      await init();
    }

    if (_isEnabled == enabled) {
      return;
    }

    try {
      _isEnabled = enabled;

      await _prefs.setBool(_musicEnabledKey, enabled);

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
    if (!_initialized) {
      await init();
    }

    if (_effectsEnabled == enabled) {
      return;
    }

    try {
      _effectsEnabled = enabled;

      await _prefs.setBool(_effectsEnabledKey, enabled);
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
    if (!_initialized) {
      await init();
    }

    if (_vibrationEnabled == enabled) {
      return;
    }

    try {
      _vibrationEnabled = enabled;

      await _prefs.setBool(_vibrationEnabledKey, enabled);
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
    if (!_vibrationEnabled) {
      return;
    }

    await HapticFeedback.lightImpact();
  }

  Future<void> mediumVibration() async {
    if (!_vibrationEnabled) {
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
    if (!_vibrationEnabled) {
      return;
    }

    await HapticFeedback.heavyImpact();
  }

  // Future<void> selectionVibration() async {
  //   if (!_vibrationEnabled) {
  //     return;
  //   }
  //
  //   await HapticFeedback.selectionClick();
  // }

  // ===========================================================================
  // VOLUME
  // ===========================================================================

  Future<void> setVolume(double volume) async {
    if (!_initialized) {
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

  Future<void> dispose() async {
    if (!_initialized) {
      return;
    }

    try {
      await Future.wait([_player.dispose(), _effectPlayer.dispose()]);
    } finally {
      _initialized = false;
    }
  }
}
