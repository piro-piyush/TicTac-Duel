import 'package:tictac_duel/lib.dart';

class AudioState extends Equatable {
  const AudioState({
    this.isEnabled = true,
    this.effectsEnabled = true,
    this.vibrationEnabled = true,
    this.isInitialized = false,
    this.isPlaying = false,
  });

  final bool isEnabled;
  final bool effectsEnabled;
  final bool vibrationEnabled;
  final bool isInitialized;
  final bool isPlaying;

  AudioState copyWith({
    bool? isEnabled,
    bool? effectsEnabled,
    bool? vibrationEnabled,
    bool? isInitialized,
    bool? isPlaying,
  }) {
    return AudioState(
      isEnabled: isEnabled ?? this.isEnabled,
      effectsEnabled: effectsEnabled ?? this.effectsEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object> get props => [
    isEnabled,
    effectsEnabled,
    vibrationEnabled,
    isInitialized,
    isPlaying,
  ];
}
