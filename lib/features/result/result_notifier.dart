import 'package:tictac_duel/lib.dart';

final resultProvider =
    NotifierProvider.family<ResultNotifier, ResultModel, ResultModel>(
      ResultNotifier.new,
    );

class ResultNotifier extends Notifier<ResultModel> {
  ResultNotifier(this._initialState);

  final ResultModel _initialState;

  late final SocketService _socketService;
  late final AudioNotifier _audioNotifier;
  late final AppNavigation _navigation;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  ResultModel build() {
    _socketService = ref.read(socketServiceProvider);
    _audioNotifier = ref.read(audioProvider.notifier);
    _navigation = ref.read(appNavigationProvider);

    ref.onDispose(() {});

    Future.microtask(_playResultFeedback);

    return _initialState;
  }

  // ===========================================================================
  // STATE
  // ===========================================================================

  bool get isLocal => state.isLocal;

  bool get isOnline => state.isOnline;

  bool get isDraw => state.isDraw;

  bool get hasWon => state.hasWon;

  bool get hasWinner => state.gameWinner != null;

  bool get isDismissed => state.isDismissed;

  bool get isCompleted => state.isCompleted;

  // ===========================================================================
  // ANIMATION
  // ===========================================================================

  String get animationPath {
    if (state.isDraw) {
      return AnimationConstants.trophyAnimation;
    }

    return state.hasWon
        ? AnimationConstants.trophyAnimation
        : AnimationConstants.loseAnimation;
  }

  // ===========================================================================
  // RESULT FEEDBACK
  // ===========================================================================

  void _playResultFeedback() {
    if (state.isDraw) {
      _audioNotifier.playRoundStart();
      return;
    }

    if (state.hasWon) {
      _audioNotifier.playWin();
      _showConfetti();
      return;
    }

    _audioNotifier.playLose();
  }

  void _showConfetti() {
    if (state.showConfetti) {
      return;
    }

    state = state.copyWith(showConfetti: true);
    _audioNotifier.playConfetti();
  }

  void dismissConfetti() {
    if (!state.showConfetti) {
      return;
    }

    state = state.copyWith(showConfetti: false);
  }

  // ===========================================================================
  // PLAYER
  // ===========================================================================

  bool isMe(PlayerModel player) => _socketService.id == player.id;

  bool isWinner(PlayerModel player) {
    return state.gameWinner?.id == player.id;
  }

  // ===========================================================================
  // NAVIGATION
  // ===========================================================================

  void goHome() {
    _navigation.goToHome();
  }

  void newGame() {
    if (state.isLocal) {
      _navigation.pushLocalGame();
      return;
    }

    _navigation.goToCreateRoom();
  }
}
