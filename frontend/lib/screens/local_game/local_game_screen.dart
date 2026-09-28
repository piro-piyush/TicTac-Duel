import 'package:tictac_duel/lib.dart';

class LocalGameScreen extends GetView<LocalGameController> {
  const LocalGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NeonBackgroundWidget(
        title: 'Local Game',
        bottomNavigationBar: NeonElevatedButton(
          label: 'START GAME',
          icon: Icons.sports_esports_rounded,
          isLoading: controller.isStarting,
          onPressed:controller.startGame,
        ),
        child: LocalGameContentWidget(
          gameType: controller.gameType,
          selectedSymbol: controller.selectedSymbol,
          selectedTheme: controller.selectedTheme,
          selectedMaxRounds: controller.selectedMaxRounds,
          selectedDifficulty: controller.selectedDifficulty,
          onGameTypeChanged: controller.setGameType,
          onSymbolChanged: controller.setSelectedSymbol,
          onThemeChanged: controller.setSelectedTheme,
          onRoundsChanged: controller.setSelectedMaxRounds,
          onDifficultyChanged: controller.setSelectedDifficulty,
        ),
      ),
    );
  }
}
