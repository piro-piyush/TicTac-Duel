import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class AudioNotifier extends Notifier<AudioState> {
  AudioNotifier();

  // ===========================================================================
  // AUDIO PLAYERS
  // ===========================================================================

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _touchPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  // ===========================================================================
  // CONSTANTS
  // ===========================================================================

  static const String _musicEnabledKey = 'background_music_enabled';
  static const String _effectsEnabledKey = 'sound_effects_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';

  static const String _logName = 'AudioNotifier';

  // ===========================================================================
  // INTERNAL STATE
  // ===========================================================================

  int _musicOperation = 0;
  bool _disposed = false;

  // Web browsers require a user interaction before audio can start.
  bool get isWeb => kIsWeb;

  // ===========================================================================
  // PROVIDER LIFECYCLE
  // ===========================================================================

  @override
  AudioState build() {
    ref.onDispose(() {
      _disposed = true;
      unawaited(_disposePlayers());
    });

    return const AudioState();
  }

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  Future<void> initialize() async {
    if (_disposed || state.isInitialized) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);

    try {
      final isEnabled =
          await storage.getBool(_musicEnabledKey) ?? true;

      final effectsEnabled =
          await storage.getBool(_effectsEnabledKey) ?? true;

      final vibrationEnabled =
          await storage.getBool(_vibrationEnabledKey) ?? true;

      if (_disposed) {
        return;
      }

      await _backgroundPlayer.setAsset(
        AudioConstants.backgroundMusic,
      );

      await _backgroundPlayer.setLoopMode(
        LoopMode.one,
      );

      await _backgroundPlayer.setVolume(0.3);

      await _touchPlayer.setAsset(
        AudioConstants.touchSound,
      );

      await _touchPlayer.setVolume(1.0);

      await _effectPlayer.setVolume(1.0);

      if (_disposed) {
        return;
      }

      state = state.copyWith(
        isEnabled: isEnabled,
        effectsEnabled: effectsEnabled,
        vibrationEnabled: vibrationEnabled,
        isInitialized: true,
      );

      if (isEnabled && !isWeb) {
        unawaited(play());
      }
    } catch (error, stackTrace) {
      await _disposePlayers();

      dev.log(
        'Failed to initialize audio notifier',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // BACKGROUND MUSIC
  // ===========================================================================

  Future<void> play() async {
    if (_disposed || !state.isInitialized || !state.isEnabled) {
      return;
    }

    final operation = ++_musicOperation;

    if (_backgroundPlayer.playing) {
      state = state.copyWith(isPlaying: true);

      return;
    }

    try {
      await _backgroundPlayer.play();

      if (_disposed) {
        return;
      }

      // A newer music operation may have disabled music
      // while this play operation was still pending.
      if (operation != _musicOperation || !state.isEnabled) {
        await _backgroundPlayer.pause();

        state = state.copyWith(isPlaying: false);

        return;
      }

      state = state.copyWith(isPlaying: true);
    } catch (error, stackTrace) {
      dev.log(
        'Failed to play music',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> pause() async {
    if (_disposed || !state.isInitialized) {
      return;
    }

    // Invalidate any pending play operation.
    _musicOperation++;

    try {
      await _backgroundPlayer.pause();

      if (!_disposed) {
        state = state.copyWith(isPlaying: false);
      }
    } catch (error, stackTrace) {
      dev.log(
        'Failed to pause music',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> stop() async {
    if (_disposed || !state.isInitialized) {
      return;
    }

    // Invalidate any pending play operation.
    _musicOperation++;

    try {
      await _backgroundPlayer.stop();

      if (!_disposed) {
        state = state.copyWith(isPlaying: false);
      }
    } catch (error, stackTrace) {
      dev.log(
        'Failed to stop music',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> resume() async {
    if (_disposed || !state.isInitialized || !state.isEnabled) {
      return;
    }

    await play();
  }

  // ===========================================================================
  // TOUCH SOUND
  // ===========================================================================

  void playTouch() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    // On Web, the first user interaction unlocks the audio context.
    if (state.isEnabled && isWeb && !_backgroundPlayer.playing) {
      unawaited(play());
    }

    if (state.effectsEnabled) {
      unawaited(_playTouchSound());
    }

    if (state.vibrationEnabled) {
      unawaited(HapticFeedback.selectionClick());
    }
  }

  Future<void> _playTouchSound() async {
    if (_disposed || !state.isInitialized || !state.effectsEnabled) {
      return;
    }

    try {
      await _touchPlayer.seek(Duration.zero);
      await _touchPlayer.play();
    } catch (error, stackTrace) {
      dev.log(
        'Failed to play touch sound',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // SOUND EFFECTS
  // ===========================================================================

  void playConfetti() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    unawaited(_playEffect(AudioConstants.confettiSound));
  }

  void playWin() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    unawaited(_playEffect(AudioConstants.winSound));
  }

  void playLose() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    unawaited(_playEffect(AudioConstants.loseSound));
  }

  void playSwoosh() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    unawaited(_playEffect(AudioConstants.comedySound));
  }

  void playRoundStart() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    unawaited(_playEffect(AudioConstants.roundSound));

    if (state.vibrationEnabled) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  void playJoin() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    unawaited(_playEffect(AudioConstants.joinSound));

    if (state.vibrationEnabled) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  Future<void> _playEffect(String asset) async {
    if (_disposed || !state.isInitialized || !state.effectsEnabled) {
      return;
    }

    try {
      await _effectPlayer.stop();

      await _effectPlayer.setAsset(asset);

      await _effectPlayer.seek(Duration.zero);

      await _effectPlayer.play();
    } catch (error, stackTrace) {
      dev.log(
        'Failed to play sound effect: $asset',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // MUSIC SETTINGS
  // ===========================================================================

  Future<void> setEnabled(bool enabled) async {
    if (_disposed || !state.isInitialized) {
      return;
    }

    if (state.isEnabled == enabled) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);

    try {
      state = state.copyWith(isEnabled: enabled);

      // Invalidate any pending play operation immediately.
      _musicOperation++;

      await storage.setBool(_musicEnabledKey, enabled);

      if (_disposed) {
        return;
      }

      if (enabled) {
        await play();
      } else {
        await _backgroundPlayer.pause();

        if (!_disposed) {
          state = state.copyWith(isPlaying: false);
        }
      }
    } catch (error, stackTrace) {
      dev.log(
        'Failed to update music setting: $enabled',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // SOUND EFFECT SETTINGS
  // ===========================================================================

  Future<void> setEffectsEnabled(bool enabled) async {
    if (_disposed || !state.isInitialized) {
      return;
    }

    if (state.effectsEnabled == enabled) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);

    try {
      state = state.copyWith(effectsEnabled: enabled);

      await storage.setBool(_effectsEnabledKey, enabled);

      if (_disposed) {
        return;
      }

      if (!enabled) {
        await Future.wait([_touchPlayer.stop(), _effectPlayer.stop()]);
      }
    } catch (error, stackTrace) {
      dev.log(
        'Failed to update sound effects setting: $enabled',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // VIBRATION / HAPTIC FEEDBACK
  // ===========================================================================

  Future<void> setVibrationEnabled(bool enabled) async {
    if (_disposed || !state.isInitialized) {
      return;
    }

    if (state.vibrationEnabled == enabled) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);

    try {
      state = state.copyWith(vibrationEnabled: enabled);

      await storage.setBool(_vibrationEnabledKey, enabled);
    } catch (error, stackTrace) {
      dev.log(
        'Failed to update vibration setting: $enabled',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> lightVibration() async {
    if (_disposed || !state.vibrationEnabled) {
      return;
    }

    try {
      await HapticFeedback.lightImpact();
    } catch (error, stackTrace) {
      dev.log(
        'Failed to trigger light vibration',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> mediumVibration() async {
    if (_disposed || !state.vibrationEnabled) {
      return;
    }

    try {
      await HapticFeedback.mediumImpact();
    } catch (error, stackTrace) {
      dev.log(
        'Failed to trigger medium vibration',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> heavyVibration() async {
    if (_disposed || !state.vibrationEnabled) {
      return;
    }

    try {
      await HapticFeedback.heavyImpact();
    } catch (error, stackTrace) {
      dev.log(
        'Failed to trigger heavy vibration',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // VOLUME
  // ===========================================================================

  Future<void> setVolume(double volume) async {
    if (_disposed || !state.isInitialized) {
      return;
    }

    final clampedVolume = volume.clamp(0.0, 1.0).toDouble();

    try {
      await Future.wait([
        _backgroundPlayer.setVolume(clampedVolume * 0.4),
        _touchPlayer.setVolume(clampedVolume),
        _effectPlayer.setVolume(clampedVolume),
      ]);
    } catch (error, stackTrace) {
      dev.log(
        'Failed to set audio volume',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  Future<void> _disposePlayers() async {
    _musicOperation++;

    try {
      await Future.wait([
        _backgroundPlayer.dispose(),
        _touchPlayer.dispose(),
        _effectPlayer.dispose(),
      ]);
    } catch (error, stackTrace) {
      dev.log(
        'Failed to dispose audio players',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

// ==============================================================================
// PROVIDER
// ==============================================================================

final audioProvider = NotifierProvider<AudioNotifier, AudioState>(
  AudioNotifier.new,
);
