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

  void setGameType(LocalGameType value) {
    _gameType.value = value;
  }

  void setSelectedSymbol(PlayerSymbol value) {
    _selectedSymbol.value = value;
  }

  void setSelectedTheme(RoomTheme value) {
    _selectedTheme.value = value;
  }

  void setSelectedMaxRounds(int value) {
    _selectedMaxRounds.value = value;
  }

  void setSelectedDifficulty(CpuDifficulty value) {
    _selectedDifficulty.value = value;
  }

  void startGame() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isStarting.value) {
      return;
    }

    _isStarting.value = true;

    try {
      final playerOne = _buildPlayer(
        id: GameConstants.localPlayerOneId,
        name: GameConstants.localPlayerOneName,
        symbol: selectedSymbol,
      );

      final isComputerGame = gameType == LocalGameType.computer;

      final playerTwo = _buildPlayer(
        id: isComputerGame
            ? GameConstants.localCpuId
            : GameConstants.localPlayerTwoId,
        name: isComputerGame
            ? GameConstants.localCpuName
            : GameConstants.localPlayerTwoName,
        symbol: _opponentSymbol,
      );

      final localGame = LocalGameModel(
        playerOne: playerOne,
        playerTwo: playerTwo,
        theme: selectedTheme,
        maxRounds: selectedMaxRounds,
        gameType: gameType,
        difficulty: _selectedDifficultyForGame,
      );

      AppNavigation.replaceLocalGameBoard(localGame);
    } catch (error, stackTrace) {
      LoggerUtils.error('LocalGameController.startGame', error, stackTrace);

      PopupUtils.showError(error.toString());
    } finally {
      _isStarting.value = false;
    }
  }

  PlayerModel _buildPlayer({
    required String id,
    required String name,
    required PlayerSymbol symbol,
  }) {
    return PlayerModel(id: id, name: name, symbol: symbol, isReady: true);
  }

  PlayerSymbol get _opponentSymbol {
    return selectedSymbol == PlayerSymbol.x ? PlayerSymbol.o : PlayerSymbol.x;
  }

  CpuDifficulty? get _selectedDifficultyForGame {
    return gameType == LocalGameType.computer ? selectedDifficulty : null;
  }
}
