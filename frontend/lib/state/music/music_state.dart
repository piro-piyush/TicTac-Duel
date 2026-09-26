import 'package:tictac_duel/lib.dart';

class MusicState extends Equatable {
  const MusicState({
    this.isInitialized = false,
    this.isEnabled = false,
    this.effectsEnabled = false,
    this.vibrationEnabled = false,
    this.isPlaying = false,
  });

  // ===========================================================================
  // State
  // ===========================================================================

  final bool isInitialized;
  final bool isEnabled;
  final bool effectsEnabled;
  final bool vibrationEnabled;
  final bool isPlaying;

  // ===========================================================================
  // Copy
  // ===========================================================================

  MusicState copyWith({
    bool? isInitialized,
    bool? isEnabled,
    bool? effectsEnabled,
    bool? vibrationEnabled,
    bool? isPlaying,
  }) {
    return MusicState(
      isInitialized: isInitialized ?? this.isInitialized,
      isEnabled: isEnabled ?? this.isEnabled,
      effectsEnabled: effectsEnabled ?? this.effectsEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  // ===========================================================================
  // Equatable
  // ===========================================================================

  @override
  List<Object> get props => [
    isInitialized,
    isEnabled,
    effectsEnabled,
    vibrationEnabled,
    isPlaying,
  ];
}
