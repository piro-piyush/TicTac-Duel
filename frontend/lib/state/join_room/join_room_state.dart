import 'package:tictac_duel/lib.dart';

class JoinRoomState extends Equatable {
  const JoinRoomState({
    this.isJoining = false,
    this.errorMessage,
  });

  final bool isJoining;
  final String? errorMessage;

  JoinRoomState copyWith({
    bool? isJoining,
    String? errorMessage,
    bool clearError = false,
  }) {
    return JoinRoomState(
      isJoining: isJoining ?? this.isJoining,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isJoining,
    errorMessage,
  ];
}