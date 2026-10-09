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

  bool _isOverlayOpen = false;

  bool get isOverlayOpen => _isOverlayOpen;

  void _markOverlayOpen() => _isOverlayOpen = true;

  void _markOverlayClosed() => _isOverlayOpen = false;

  void closeOpenDialog() {
    if (!_isOverlayOpen) return;

    if (_navigator.canPop()) {
      _navigator.pop();
    }

    _markOverlayClosed();
  }

  double _getMaxWidth(double screenWidth) {
    if (screenWidth < Dimens.mobileBreakpoint) {
      return screenWidth;
    }

    if (screenWidth < Dimens.tabletBreakpoint) {
      return Dimens.tabletMaxContentWidth;
    }

    return Dimens.desktopMaxContentWidth;
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
    _markOverlayOpen();

    return showDialog<T>(
      context: _context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final maxContentWidth = _getMaxWidth(screenWidth);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: builder(context),
          ),
        );
      },
    ).whenComplete(_markOverlayClosed);
  }

  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    _markOverlayOpen();

    return showModalBottomSheet<T>(
      context: _context,
      builder: builder,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      shape: shape,
    ).whenComplete(_markOverlayClosed);
  }
}
