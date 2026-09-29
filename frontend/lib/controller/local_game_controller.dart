import 'package:tictac_duel/lib.dart';

class LocalGameController extends GetxController {
  final Rx<LocalGameType> _gameType = LocalGameType.friend.obs;
  final Rx<PlayerSymbol> _selectedSymbol = PlayerSymbol.x.obs;
  final Rx<RoomTheme> _selectedTheme = RoomTheme.classic.obs;
  final RxInt _selectedMaxRounds = GameConstants.roundOptions.first.obs;
  final Rx<CpuDifficulty> _selectedDifficulty = CpuDifficulty.medium.obs;
  final RxBool _isStarting = false.obs;

  LocalGameType get gameType => _gameType.value;

  PlayerSymbol get selectedSymbol => _selectedSymbol.value;

  RoomTheme get selectedTheme => _selectedTheme.value;

  int get selectedMaxRounds => _selectedMaxRounds.value;

  CpuDifficulty get selectedDifficulty => _selectedDifficulty.value;

  bool get isStarting => _isStarting.value;

  void setGameType(LocalGameType value) => _gameType.value = value;

  void setSelectedSymbol(PlayerSymbol value) => _selectedSymbol.value = value;

  void setSelectedTheme(RoomTheme value) => _selectedTheme.value = value;

  void setSelectedMaxRounds(int value) => _selectedMaxRounds.value = value;

  void setSelectedDifficulty(CpuDifficulty value) {
    _selectedDifficulty.value = value;
  }

  void startGame() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (isStarting) return;
    _isStarting.value = true;
    try {
      final playerOne = LocalPlayerModel(
        id: GameConstants.localPlayerOneId,
        name: gameType == LocalGameType.computer
            ? GameConstants.localPlayerName
            : GameConstants.localPlayerOneName,
        symbol: selectedSymbol,
      );
      final game = switch (gameType) {
        LocalGameType.friend => LocalGameModel.friend(
          playerOne: playerOne,
          playerTwo: LocalPlayerModel(
            id: GameConstants.localPlayerTwoId,
            name: GameConstants.localPlayerTwoName,
            symbol: _opponentSymbol,
          ),
          theme: selectedTheme,
          maxRounds: selectedMaxRounds,
        ),
        LocalGameType.computer => LocalGameModel.computer(
          playerOne: playerOne,
          theme: selectedTheme,
          maxRounds: selectedMaxRounds,
          difficulty: selectedDifficulty,
        ),
      };
      AppNavigation.replaceLocalGameBoard(game);
    } catch (error, stackTrace) {
      LoggerUtils.error('LocalGameController.startGame', error, stackTrace);
      PopupUtils.showError(error.toString());
    } finally {
      _isStarting.value = false;
    }
  }

  PlayerSymbol get _opponentSymbol =>
      selectedSymbol == PlayerSymbol.x ? PlayerSymbol.o : PlayerSymbol.x;
}
