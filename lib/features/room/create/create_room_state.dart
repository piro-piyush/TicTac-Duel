import 'package:tictac_duel/lib.dart';

class CreateRoomState extends Equatable {
  const CreateRoomState({
    this.selectedSymbol = GameConstants.defaultLocalPlayerSymbol,
    this.selectedTheme = GameConstants.defaultLocalTheme,
    this.selectedMaxRounds = GameConstants.defaultMaxRounds,
    this.isRoomPrivate = true,
    this.isCreating = false,
  });

  final PlayerSymbol selectedSymbol;
  final RoomTheme selectedTheme;
  final int selectedMaxRounds;
  final bool isRoomPrivate;
  final bool isCreating;

  CreateRoomState copyWith({
    PlayerSymbol? selectedSymbol,
    RoomTheme? selectedTheme,
    int? selectedMaxRounds,
    bool? isRoomPrivate,
    bool? isCreating,
  }) => CreateRoomState(
    selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    selectedTheme: selectedTheme ?? this.selectedTheme,
    selectedMaxRounds: selectedMaxRounds ?? this.selectedMaxRounds,
    isRoomPrivate: isRoomPrivate ?? this.isRoomPrivate,
    isCreating: isCreating ?? this.isCreating,
  );

  static CreateRoomState initial() => const CreateRoomState();

  @override
  List<Object?> get props => [
    selectedSymbol,
    selectedTheme,
    selectedMaxRounds,
    isRoomPrivate,
    isCreating,
  ];
}
