import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicAndFeedbackService {
  MusicAndFeedbackService._();

  static final MusicAndFeedbackService instance =
  MusicAndFeedbackService._();

  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _musicEnabled = true;
  bool _vibrationEnabled = true;

  bool get musicEnabled => _musicEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  // ---------------------------------------------------------------------------
  // Music
  // ---------------------------------------------------------------------------

  Future<void> initialize() async {
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playMusic() async {
    if (!_musicEnabled) {
      return;
    }

    if (_musicPlayer.state == PlayerState.playing) {
      return;
    }

    await _musicPlayer.play(
      AssetSource('audio/background_music.mp3'),
    );
  }

  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (!_musicEnabled) {
      return;
    }

    await _musicPlayer.resume();
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;

    if (enabled) {
      await playMusic();
    } else {
      await stopMusic();
    }
  }

  // ---------------------------------------------------------------------------
  // Vibration / Haptic Feedback
  // ---------------------------------------------------------------------------

  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
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

    await HapticFeedback.mediumImpact();
  }

  Future<void> heavyVibration() async {
    if (!_vibrationEnabled) {
      return;
    }

    await HapticFeedback.heavyImpact();
  }

  Future<void> selectionVibration() async {
    if (!_vibrationEnabled) {
      return;
    }

    await HapticFeedback.selectionClick();
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  Future<void> dispose() async {
    await _musicPlayer.dispose();
  }
}