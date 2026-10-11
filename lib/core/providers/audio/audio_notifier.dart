import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class AudioNotifier extends Notifier<AudioState> {
  AudioNotifier();

  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _sources = {};

  AudioSource? _backgroundSource;
  SoundHandle? _musicHandle;

  bool _disposed = false;
  bool _ownsEngine = false;
  bool _initializing = false;
  int _musicOperation = 0;

  bool get isWeb => kIsWeb;

  @override
  AudioState build() {
    ref.onDispose(() {
      _disposed = true;
      unawaited(_disposeAudioEngine());
    });

    return const AudioState();
  }

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  Future<void> initialize() async {
    if (_disposed || state.isInitialized || _initializing) return;

    _initializing = true;

    try {
      final storage = ref.read(localStorageServiceProvider);

      final settings = await Future.wait([
        storage.getBool(AudioConstants.musicEnabledKey),
        storage.getBool(AudioConstants.effectsEnabledKey),
        storage.getBool(AudioConstants.vibrationEnabledKey),
      ]);

      if (_disposed) return;

      _ownsEngine = !_soloud.isInitialized;
      if (_ownsEngine) await _soloud.init();

      _backgroundSource = await _loadSource(AudioConstants.backgroundMusic);

      await Future.wait([
        _loadSource(AudioConstants.touchSound),
        _loadSource(AudioConstants.confettiSound),
        _loadSource(AudioConstants.winSound),
        _loadSource(AudioConstants.loseSound),
        _loadSource(AudioConstants.comedySound),
        _loadSource(AudioConstants.swordSound),
        _loadSource(AudioConstants.roundSound),
        _loadSource(AudioConstants.joinSound),
      ]);

      if (_disposed) return;

      state = state.copyWith(
        isEnabled: settings[0] ?? true,
        effectsEnabled: settings[1] ?? true,
        vibrationEnabled: settings[2] ?? true,
        isInitialized: true,
      );

      if (state.isEnabled && !isWeb) unawaited(play());
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to initialize audio', error, stackTrace);

      await _disposeAudioEngine();

      if (!_disposed) rethrow;
    } finally {
      _initializing = false;
    }
  }

  Future<AudioSource> _loadSource(String asset) async {
    final cached = _sources[asset];
    if (cached != null) return cached;

    final source = await _soloud.loadAsset(asset);

    if (_disposed) {
      await _soloud.disposeSource(source);
      throw StateError('AudioNotifier was disposed during initialization.');
    }

    _sources[asset] = source;
    return source;
  }

  Future<void> play() async {
    if (_disposed || !state.isInitialized || !state.isEnabled) return;
    _startBackgroundMusic();
  }

  void _startBackgroundMusic() {
    if (_disposed || !state.isInitialized || !state.isEnabled) return;

    final source = _backgroundSource;
    if (source == null) return;

    try {
      final handle = _musicHandle;

      if (handle != null && _soloud.getIsValidVoiceHandle(handle)) {
        if (!state.isPlaying) _soloud.pauseSwitch(handle);

        state = state.copyWith(isPlaying: true);
        return;
      }

      _musicHandle = _soloud.play(
        source,
        looping: true,
        volume: AudioConstants.defaultBackgroundVolume,
      );

      state = state.copyWith(isPlaying: true);
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to play music', error, stackTrace);
    }
  }

  // ---------------------------------------------------------------------------
  // TOUCH AND SOUND EFFECTS
  // ---------------------------------------------------------------------------

  void playTouch() {
    if (_disposed || !state.isInitialized) return;

    if (isWeb && state.isEnabled) _startBackgroundMusic();
    if (state.effectsEnabled) _playSound(AudioConstants.touchSound);

    if (state.vibrationEnabled && !isWeb) {
      unawaited(HapticFeedback.selectionClick());
    }
  }

  void _playSound(String asset) {
    if (_disposed || !state.isInitialized || !state.effectsEnabled) return;

    final source = _sources[asset];
    if (source == null) return;

    final volume = asset == AudioConstants.touchSound
        ? AudioConstants.defaultTouchVolume
        : AudioConstants.defaultEffectVolume;

    try {
      _soloud.play(source, volume: volume);
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to play sound: $asset', error, stackTrace);
    }
  }

  void playConfetti() => _playSound(AudioConstants.confettiSound);

  void playWin() => _playSound(AudioConstants.winSound);

  void playLose() => _playSound(AudioConstants.loseSound);

  void playSwoosh() => _playSound(AudioConstants.comedySound);

  void playDraw() => _playSound(AudioConstants.swordSound);

  void playRoundStart() {
    _playSound(AudioConstants.roundSound);
    if (state.vibrationEnabled && !isWeb) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  void playJoin() {
    _playSound(AudioConstants.joinSound);
    if (state.vibrationEnabled && !isWeb) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  Future<void> setEnabled(bool enabled) async {
    if (_disposed || !state.isInitialized || state.isEnabled == enabled) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);
    final operation = ++_musicOperation;

    state = state.copyWith(isEnabled: enabled);

    // Start or pause immediately, before awaiting storage.
    if (enabled) {
      _startBackgroundMusic();
    } else {
      final handle = _musicHandle;

      if (handle != null && _soloud.getIsValidVoiceHandle(handle)) {
        _soloud.pauseSwitch(handle);
      }

      state = state.copyWith(isPlaying: false);
    }

    try {
      await storage.setBool(AudioConstants.musicEnabledKey, enabled);

      if (_disposed || operation != _musicOperation) return;
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'Failed to update music setting: $enabled',
        error,
        stackTrace,
      );

      rethrow;
    }
  }

  Future<void> setEffectsEnabled(bool enabled) async {
    if (_disposed || !state.isInitialized || state.effectsEnabled == enabled) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);
    state = state.copyWith(effectsEnabled: enabled);

    try {
      await storage.setBool(AudioConstants.effectsEnabledKey, enabled);

      if (_disposed || enabled) return;

      for (final entry in _sources.entries) {
        if (entry.key != AudioConstants.backgroundMusic) {
          _soloud.stopAudioSource(entry.value);
        }
      }
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'Failed to update sound effects setting: $enabled',
        error,
        stackTrace,
      );

      rethrow;
    }
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    if (_disposed ||
        !state.isInitialized ||
        state.vibrationEnabled == enabled) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);
    state = state.copyWith(vibrationEnabled: enabled);

    try {
      await storage.setBool(AudioConstants.vibrationEnabledKey, enabled);
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'Failed to update vibration setting: $enabled',
        error,
        stackTrace,
      );

      rethrow;
    }
  }

  Future<void> lightVibration() async {
    if (_disposed || !state.vibrationEnabled || isWeb) return;

    try {
      await HapticFeedback.lightImpact();
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to trigger light vibration', error, stackTrace);
    }
  }

  Future<void> mediumVibration() async {
    if (_disposed || !state.vibrationEnabled || isWeb) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'Failed to trigger medium vibration',
        error,
        stackTrace,
      );
    }
  }

  Future<void> heavyVibration() async {
    if (_disposed || !state.vibrationEnabled || isWeb) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to trigger heavy vibration', error, stackTrace);
    }
  }

  Future<void> _disposeAudioEngine() async {
    _musicOperation++;
    if (!_soloud.isInitialized) return;
    try {
      for (final source in _sources.values.toSet()) {
        if (_soloud.isInitialized && _soloud.isValidAudioSource(source)) {
          await _soloud.disposeSource(source);
        }
      }
      _sources.clear();
      if (_ownsEngine && _soloud.isInitialized) {
        await _soloud.deinitAsync();
      }
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'Failed to dispose SoLoud resources',
        error,
        stackTrace,
      );
    }
  }
}

final audioProvider = NotifierProvider<AudioNotifier, AudioState>(
  AudioNotifier.new,
);
