import 'package:tictac_duel/lib.dart';

class CreateRoomState extends Equatable {
  const CreateRoomState({
    this.isCreating = false,
    this.errorMessage,
  });

  final bool isCreating;
  final String? errorMessage;

  CreateRoomState copyWith({
    bool? isCreating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateRoomState(
      isCreating: isCreating ?? this.isCreating,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isCreating,
    errorMessage,
  ];
}