import 'package:tictac_duel/lib.dart';

class CreateRoomState extends Equatable {
  const CreateRoomState({
    this.selectedSymbol = GameConstants.defaultLocalPlayerSymbol,
    this.selectedTheme = GameConstants.defaultLocalTheme,
    this.selectedMaxRounds = GameConstants.defaultMaxRounds,
    this.isRoomPrivate = true,
    this.isCreating = false,
    this.errorMessage,
  });

  final PlayerSymbol selectedSymbol;
  final RoomTheme selectedTheme;
  final int selectedMaxRounds;
  final bool isRoomPrivate;

  final bool isCreating;
  final String? errorMessage;

  CreateRoomState copyWith({
    PlayerSymbol? selectedSymbol,
    RoomTheme? selectedTheme,
    int? selectedMaxRounds,
    bool? isRoomPrivate,
    bool? isCreating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateRoomState(
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      selectedMaxRounds: selectedMaxRounds ?? this.selectedMaxRounds,
      isRoomPrivate: isRoomPrivate ?? this.isRoomPrivate,
      isCreating: isCreating ?? this.isCreating,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedSymbol,
    selectedTheme,
    selectedMaxRounds,
    isRoomPrivate,
    isCreating,
    errorMessage,
  ];
}