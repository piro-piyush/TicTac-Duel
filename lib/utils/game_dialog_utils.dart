import 'package:tictac_duel/lib.dart';

final gameDialogProvider = Provider<GameDialogUtils>(
  (ref) => GameDialogUtils(ref.watch(appNavigationProvider)),
);

class GameDialogUtils {
  GameDialogUtils(this._navigation);

  final AppNavigation _navigation;

  static final rootNavigatorKey = AppPages.rootNavigatorKey;

  NavigatorState get _navigator => rootNavigatorKey.currentState!;

  BuildContext get _context => _navigator.context;

  bool _isDialogOpen = false;

  bool get isDialogOpen => _isDialogOpen;
  bool _isModalOpen = false;

  bool get isModalOpen => _isModalOpen;

  void _markModalOpen() => _isModalOpen = true;

  void _markModalClosed() => _isModalOpen = false;

  void _markDialogOpen() => _isDialogOpen = true;

  void _markDialogClosed() => _isDialogOpen = false;

  void closeOpenDialog() {
    if (!_isDialogOpen) return;

    if (_navigator.canPop()) {
      _navigator.pop();
    }

    _markDialogClosed();
  }

  Future<void> showGameResult({
    required GameResult result,
    required PlayerSymbol mySymbol,
    VoidCallback? onConfirm,
  }) => _show(
    builder: (_) => RoundResultDialog(
      result: result,
      mySymbol: mySymbol,
      onConfirm: onConfirm,
    ),
    barrierDismissible: false,
  );

  Future<void> showRoomClosed({required GameDismissReason reason}) => _show(
    builder: (_) => RoomClosedDialog(
      reason: reason,
      onBack: _navigator.pop,
      onHome: _navigation.goToHome,
    ),
    barrierDismissible: false,
  );

  Future<void> showPrivacyPolicy() =>
      _show(builder: (_) => const PrivacyPolicyDialog());

  Future<bool> confirmQuit() async =>
      await _show<bool>(
        builder: (_) => const QuitDialog(),
        barrierDismissible: false,
      ) ??
      false;

  void showAbout() => showAboutDialog(
    context: _context,
    applicationName: GameConstants.appName,
    applicationVersion: GameConstants.appVersion,
    applicationIcon: const Icon(
      Icons.grid_3x3_rounded,
      color: AppColors.neonCyan,
      size: Dimens.fiftySix,
    ),
    children: [
      const Text(GameConstants.appDescription, textAlign: TextAlign.center),
    ],
  );

  Future<T?> show<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) => _show<T>(
    builder: (_) => child,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
  );

  Future<T?> _show<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    _markDialogOpen();

    return showDialog<T>(
      context: _context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: builder,
    ).whenComplete(_markDialogClosed);
  }

  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    _markModalOpen();

    return showModalBottomSheet<T>(
      context: _context,
      builder: builder,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      shape: shape,
    ).whenComplete(_markModalClosed);
  }
}
