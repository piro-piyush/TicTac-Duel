import 'package:tictac_duel/constants/animation_constants.dart';
import 'package:tictac_duel/lib.dart';

class ResultController extends GetxController {
  ResultController({required ResultModel initialState})
    : _state = initialState.obs;

  final Rx<ResultModel> _state;

  SocketService get _socketService => Get.find<SocketService>();

  ResultModel get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    playResultFeedback();
  }

  void playResultFeedback() {
    if (!state.isValid) {
      return;
    }

    final musicController = Get.find<MusicController>();

    if (state.hasWon) {
      musicController.playWin();
    } else if (state.isDraw) {
      musicController.playRoundStart();
    } else {
      musicController.playLose();
    }

    if (state.hasWon) {
      _state.value = state.copyWith(showConfetti: true);
    }
  }

  void dismissConfetti() {
    _state.value = state.copyWith(showConfetti: false);
  }

  bool isMe(PlayerModel player) {
    return player.socketId == _socketService.socketId;
  }

  bool isWinner(PlayerModel player) {
    return state.gameWinner?.socketId == player.socketId;
  }

  void goHome() {
    AppNavigation.goToHome();
  }

  void newGame() {
    AppNavigation.goToCreateRoom();
  }

  String get animationPath {
    return state.hasWon
        ? AnimationConstants.trophyAnimation
        : AnimationConstants.loseAnimation;
  }
}
