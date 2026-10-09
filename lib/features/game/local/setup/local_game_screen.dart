import 'package:tictac_duel/lib.dart';

class LocalGameScreen extends ConsumerWidget {
  const LocalGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localGameProvider);
    final notifier = ref.read(localGameProvider.notifier);

    return NeonBackgroundWidget(
      title: 'Local Game',
      bottomNavigationBar: NeonElevatedButtonWidget.icon(
        label: 'START GAME',
        icon: Icons.sports_esports_rounded,
        isLoading: state.isStarting,
        onPressed: notifier.startGame,
      ),
      child: LocalGameContentWidget(
        gameType: state.gameType,
        selectedSymbol: state.selectedSymbol,
        selectedTheme: state.selectedTheme,
        selectedMaxRounds: state.selectedMaxRounds,
        selectedDifficulty: state.selectedDifficulty,
        onGameTypeChanged: notifier.setGameType,
        onSymbolChanged: notifier.setSelectedSymbol,
        onThemeChanged: notifier.setSelectedTheme,
        onRoundsChanged: notifier.setSelectedMaxRounds,
        onDifficultyChanged: notifier.setSelectedDifficulty,
      ),
    );
  }
}
