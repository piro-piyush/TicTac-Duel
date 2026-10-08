import 'package:tictac_duel/lib.dart';

class LocalGameContentWidget extends StatelessWidget {
  const LocalGameContentWidget({
    super.key,
    required this.gameType,

    required this.selectedSymbol,
    required this.selectedTheme,
    required this.selectedMaxRounds,
    required this.selectedDifficulty,
    required this.onGameTypeChanged,
    required this.onSymbolChanged,
    required this.onThemeChanged,
    required this.onRoundsChanged,
    required this.onDifficultyChanged,
  });

  final LocalGameType gameType;

  final PlayerSymbol selectedSymbol;
  final RoomTheme selectedTheme;
  final int selectedMaxRounds;
  final CpuDifficulty selectedDifficulty;

  final ValueChanged<LocalGameType> onGameTypeChanged;
  final ValueChanged<PlayerSymbol> onSymbolChanged;
  final ValueChanged<RoomTheme> onThemeChanged;
  final ValueChanged<int> onRoundsChanged;
  final ValueChanged<CpuDifficulty> onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spaceBtwSections,
      children: [
        GameTypeSelectorWidget(
          gameType: gameType,
          onGameTypeChanged: onGameTypeChanged,
        ),

        if (gameType == LocalGameType.computer)
          GameDifficultySectionWidget(
            selectedDifficulty: selectedDifficulty,
            onDifficultyChanged: onDifficultyChanged,
          ),

        ChooseYourSymbolWidget(
          selectedSymbol: selectedSymbol,
          onSymbolChanged: onSymbolChanged,
        ),

        SelectRoomThemeWidget(
          selectedTheme: selectedTheme,
          onThemeChanged: onThemeChanged,
        ),

        RoundSelectorWidget(
          onRoundChanged: onRoundsChanged,
          selectedRounds: selectedMaxRounds,
        ),
      ],
    );
  }


}
