import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class AudioNotifier extends Notifier<AudioState> {
  AudioNotifier();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _touchPlayer = AudioPlayer();
  final List<AudioPlayer> _effectPlayers = [
    AudioPlayer(),
    AudioPlayer(),
    AudioPlayer(),
  ];
  static const String _logName = 'AudioNotifier';
  bool _webMusicStartAttempted = false;
  int _musicOperation = 0;
  int _effectPlayerIndex = 0;
  bool _disposed = false;

  bool get isWeb => kIsWeb;

  @override
  AudioState build() {
    ref.onDispose(() {
      _disposed = true;
      unawaited(_disposePlayers());
    });

    return const AudioState();
  }

  Future<void> initialize() async {
    if (_disposed || state.isInitialized) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);

    try {
      final isEnabled =
          await storage.getBool(AudioConstants.musicEnabledKey) ?? true;

      final effectsEnabled =
          await storage.getBool(AudioConstants.effectsEnabledKey) ?? true;

      final vibrationEnabled =
          await storage.getBool(AudioConstants.vibrationEnabledKey) ?? true;

      if (_disposed) {
        return;
      }

      await _backgroundPlayer.setAsset(AudioConstants.backgroundMusic);

      await _backgroundPlayer.setLoopMode(LoopMode.one);

      await _backgroundPlayer.setVolume(AudioConstants.defaultBackgroundVolume);

      await _touchPlayer.setAsset(AudioConstants.touchSound);

      await _touchPlayer.setVolume(AudioConstants.defaultTouchVolume);

      for (final player in _effectPlayers) {
        await player.setVolume(AudioConstants.defaultEffectVolume);
      }

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
      dev.log(
        'Failed to initialize audio notifier',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );

      await _disposePlayers();

      if (!_disposed) {
        rethrow;
      }
    }
  }

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
      _backgroundPlayer.play();

      if (_disposed) {
        return;
      }

      if (operation != _musicOperation || !state.isEnabled) {
        _backgroundPlayer.pause();

        if (!_disposed) {
          state = state.copyWith(isPlaying: false);
        }

        return;
      }

      state = state.copyWith(
        isPlaying: _backgroundPlayer.playing,
      );
    } catch (error, stackTrace) {
      dev.log(
        'Failed to play music',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // Future<void> pause() async {
  //   if (_disposed || !state.isInitialized) {
  //     return;
  //   }
  //
  //   _musicOperation++;
  //
  //   try {
  //     await _backgroundPlayer.pause();
  //
  //     if (!_disposed) {
  //       state = state.copyWith(isPlaying: false);
  //     }
  //   } catch (error, stackTrace) {
  //     dev.log(
  //       'Failed to pause music',
  //       name: _logName,
  //       error: error,
  //       stackTrace: stackTrace,
  //     );
  //   }
  // }

  // Future<void> stop() async {
  //   if (_disposed || !state.isInitialized) {
  //     return;
  //   }
  //
  //   _musicOperation++;
  //
  //   try {
  //     await _backgroundPlayer.stop();
  //
  //     if (!_disposed) {
  //       state = state.copyWith(isPlaying: false);
  //     }
  //   } catch (error, stackTrace) {
  //     dev.log(
  //       'Failed to stop music',
  //       name: _logName,
  //       error: error,
  //       stackTrace: stackTrace,
  //     );
  //   }
  // }

  // Future<void> resume() async {
  //   if (_disposed || !state.isInitialized || !state.isEnabled) {
  //     return;
  //   }
  //
  //   await play();
  // }

  void playTouch() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    // Web browsers may require a user gesture to start audio.
    // Attempt automatic startup only on the first interaction.
    if (isWeb && state.isEnabled && !_webMusicStartAttempted) {
      _webMusicStartAttempted = true;
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

  void playDraw() {
    if (_disposed || !state.isInitialized) {
      return;
    }

    unawaited(_playEffect(AudioConstants.swordSound));
  }

  // void playMove() {
  //   if (_disposed || !state.isInitialized) {
  //     return;
  //   }
  //
  //   unawaited(_playEffect(AudioConstants.moveSound));
  // }

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

    final player = _nextEffectPlayer();

    try {
      await player.stop();

      if (_disposed || !state.effectsEnabled) {
        return;
      }

      await player.setAsset(asset);

      if (_disposed || !state.effectsEnabled) {
        return;
      }

      await player.seek(Duration.zero);

      if (_disposed || !state.effectsEnabled) {
        return;
      }

      await player.play();
    } catch (error, stackTrace) {
      if (_disposed) {
        return;
      }

      dev.log(
        'Failed to play sound effect: $asset',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  AudioPlayer _nextEffectPlayer() {
    final player = _effectPlayers[_effectPlayerIndex];

    _effectPlayerIndex = (_effectPlayerIndex + 1) % _effectPlayers.length;

    return player;
  }

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

      _musicOperation++;

      await storage.setBool(AudioConstants.musicEnabledKey, enabled);

      if (_disposed) {
        return;
      }

      if (enabled) {
        await play();
      } else {
        _backgroundPlayer.pause();
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

      await storage.setBool(AudioConstants.effectsEnabledKey, enabled);

      if (_disposed) {
        return;
      }

      if (!enabled) {
        await Future.wait([
          _touchPlayer.stop(),
          ..._effectPlayers.map((player) => player.stop()),
        ]);
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

      await storage.setBool(AudioConstants.vibrationEnabledKey, enabled);
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

  Future<void> setVolume(double volume) async {
    if (_disposed || !state.isInitialized) {
      return;
    }

    final clampedVolume = volume.clamp(0.0, 1.0).toDouble();

    try {
      await Future.wait([
        _backgroundPlayer.setVolume(clampedVolume * 0.4),
        _touchPlayer.setVolume(clampedVolume),
        ..._effectPlayers.map((player) => player.setVolume(clampedVolume)),
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

  Future<void> _disposePlayers() async {
    _musicOperation++;

    try {
      await Future.wait([
        _backgroundPlayer.dispose(),
        _touchPlayer.dispose(),
        ..._effectPlayers.map((player) => player.dispose()),
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

final audioProvider = NotifierProvider<AudioNotifier, AudioState>(
  AudioNotifier.new,
);
