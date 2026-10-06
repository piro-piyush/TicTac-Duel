import 'package:tictac_duel/lib.dart';

class PlayerState extends Equatable {
  const PlayerState({
    this.playerId,
    this.isInitialized = false,
  });

  final String? playerId;
  final bool isInitialized;

  PlayerState copyWith({
    String? playerId,
    bool? isInitialized,
  }) {
    return PlayerState(
      playerId: playerId ?? this.playerId,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
    playerId,
    isInitialized,
  ];
}