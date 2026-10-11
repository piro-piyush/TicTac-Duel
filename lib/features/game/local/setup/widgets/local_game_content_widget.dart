import 'package:tictac_duel/lib.dart';

class LocalGameContentWidget extends StatelessWidget {
  const LocalGameContentWidget({
    super.key,
    required this.gameType,
    required this.selectedSymbol,
    required this.selectedTheme,
    required this.selectedMaxRounds,
    required this.selectedDifficulty,
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

  final ValueChanged<PlayerSymbol> onSymbolChanged;
  final ValueChanged<RoomTheme> onThemeChanged;
  final ValueChanged<int> onRoundsChanged;
  final ValueChanged<CpuDifficulty> onDifficultyChanged;

  Widget _animateSection(Widget child, Duration delay) => child
      .animate()
      .fadeIn(delay: delay, duration: AnimationConstants.medium)
      .slideY(
        begin: AnimationConstants.slideSmall,
        end: 0,
        delay: delay,
        duration: AnimationConstants.medium,
        curve: AnimationConstants.defaultCurve,
      );

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
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
    ];

    return Column(
      spacing: Dimens.spaceBtwSections,
      children: [
        for (var index = 0; index < sections.length; index++)
          _animateSection(
            sections[index],
            AnimationConstants.staggerShort * index,
          ),
      ],
    );
  }
}
