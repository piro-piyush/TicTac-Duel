import 'package:tictac_duel/constants/animation_constants.dart';
import 'package:tictac_duel/lib.dart';

class ResultController extends GetxController {
  ResultController({
    required ResultModel initialState,
    required this._playerController,
    required this._musicController,
  }) : _state = initialState.obs;

  final Rx<ResultModel> _state;

  final PlayerController _playerController;
  final MusicController _musicController;

  ResultModel get state => _state.value;

  bool get isLocal => state.isLocal;

  bool get isOnline => state.isOnline;

  bool get isDraw => state.isDraw;

  bool get hasWon => state.hasWon;

  bool get hasWinner => state.gameWinner != null;

  String get animationPath => state.isDraw
      ? AnimationConstants.trophyAnimation
      : state.hasWon
      ? AnimationConstants.trophyAnimation
      : AnimationConstants.loseAnimation;

  @override
  void onInit() {
    super.onInit();
    _playResultFeedback();
  }

  void _playResultFeedback() {
    if (state.isDraw) {
      _musicController.playRoundStart();
      return;
    }

    if (state.hasWon) {
      _musicController.playWin();
      _showConfetti();
      return;
    }

    _musicController.playLose();
  }

  void _showConfetti() {
    _state.value = state.copyWith(showConfetti: true);
    _musicController.playConfetti();
  }

  void dismissConfetti() {
    if (!state.showConfetti) {
      return;
    }

    _state.value = state.copyWith(showConfetti: false);
  }

  bool isMe(PlayerModel player) {
    if (!_playerController.isInitialized) {
      return false;
    }

    return player.id == _playerController.playerId;
  }

  bool isWinner(PlayerModel player) {
    return state.gameWinner?.id == player.id;
  }

  void goHome() {
    AppNavigation.goToHome();
  }

  void newGame() {
    if (isLocal) {
      AppNavigation.pushLocalGame();
      return;
    }

    AppNavigation.replaceCreateRoom();
  }
}
