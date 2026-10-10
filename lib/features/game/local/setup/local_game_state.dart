import 'package:tictac_duel/lib.dart';

class LocalGameState extends Equatable {
  const LocalGameState({
    this.gameType = GameConstants.defaultLocalGameType,
    this.selectedSymbol = GameConstants.defaultLocalPlayerSymbol,
    this.selectedTheme = GameConstants.defaultLocalTheme,
    this.selectedMaxRounds = GameConstants.defaultMaxRounds,
    this.selectedDifficulty = GameConstants.defaultCpuDifficulty,
    this.isStarting = false,
  });

  final LocalGameType gameType;
  final PlayerSymbol selectedSymbol;
  final RoomTheme selectedTheme;
  final int selectedMaxRounds;
  final CpuDifficulty selectedDifficulty;
  final bool isStarting;

  LocalGameState copyWith({
    LocalGameType? gameType,
    PlayerSymbol? selectedSymbol,
    RoomTheme? selectedTheme,
    int? selectedMaxRounds,
    CpuDifficulty? selectedDifficulty,
    bool? isStarting,
  }) => LocalGameState(
    gameType: gameType ?? this.gameType,
    selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    selectedTheme: selectedTheme ?? this.selectedTheme,
    selectedMaxRounds: selectedMaxRounds ?? this.selectedMaxRounds,
    selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
    isStarting: isStarting ?? this.isStarting,
  );

  @override
  List<Object> get props => [
    gameType,
    selectedSymbol,
    selectedTheme,
    selectedMaxRounds,
    selectedDifficulty,
    isStarting,
  ];
}
