import 'package:tictac_duel/lib.dart';

final localGameProvider = NotifierProvider<LocalGameNotifier, LocalGameState>(
  LocalGameNotifier.new,
);

class LocalGameNotifier extends Notifier<LocalGameState> {
  late final AppNavigation _navigation;

  @override
  LocalGameState build() {
    _navigation = ref.read(appNavigationProvider);

    return const LocalGameState();
  }

  // ===========================================================================
  // SETTERS
  // ===========================================================================

  void setGameType(LocalGameType value) {
    state = state.copyWith(gameType: value);
  }

  void setSelectedSymbol(PlayerSymbol value) {
    state = state.copyWith(selectedSymbol: value);
  }

  void setSelectedTheme(RoomTheme value) {
    state = state.copyWith(selectedTheme: value);
  }

  void setSelectedMaxRounds(int value) {
    state = state.copyWith(selectedMaxRounds: value);
  }

  void setSelectedDifficulty(CpuDifficulty value) {
    state = state.copyWith(selectedDifficulty: value);
  }

  // ===========================================================================
  // START GAME
  // ===========================================================================

  void startGame() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (state.isStarting) {
      return;
    }

    state = state.copyWith(isStarting: true);

    try {
      final playerOne = PlayerModel(
        id: GameConstants.localPlayerOneId,
        name: state.gameType == LocalGameType.computer
            ? GameConstants.localPlayerName
            : GameConstants.localPlayerOneName,
        symbol: state.selectedSymbol,
      );

      final game = switch (state.gameType) {
        LocalGameType.friend => LocalGameModel.friend(
          playerOne: playerOne,
          playerTwo: PlayerModel(
            id: GameConstants.localPlayerTwoId,
            name: GameConstants.localPlayerTwoName,
            symbol: _opponentSymbol,
          ),
          theme: state.selectedTheme,
          maxRounds: state.selectedMaxRounds,
        ),
        LocalGameType.computer => LocalGameModel.computer(
          playerOne: playerOne,
          theme: state.selectedTheme,
          maxRounds: state.selectedMaxRounds,
          difficulty: state.selectedDifficulty,
        ),
      };

      _navigation.pushLocalGameBoard(game: game);
    } catch (error, stackTrace) {
      LoggerUtils.error('LocalGameNotifier.startGame', error, stackTrace);

      PopupUtils.showError(error.toString());
    } finally {
      state = state.copyWith(isStarting: false);
    }
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  PlayerSymbol get _opponentSymbol {
    return state.selectedSymbol == PlayerSymbol.x
        ? PlayerSymbol.o
        : PlayerSymbol.x;
  }
}
