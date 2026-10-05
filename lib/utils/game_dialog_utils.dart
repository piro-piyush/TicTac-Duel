import 'package:tictac_duel/lib.dart';

class GameDialogUtils {
  GameDialogUtils._();

  static NavigatorState get _navigator =>
      AppPages.rootNavigatorKey.currentState!;

  static BuildContext get _context => _navigator.context;

  // ===========================================================================
  // ROUND RESULT
  // ===========================================================================

  static Future<void> showGameResult({
    required GameResult result,
    required PlayerSymbol mySymbol,
    VoidCallback? onConfirm,
  }) {
    final isDraw = result == GameResult.draw;
    final hasWon = result.winner == mySymbol;

    final title = isDraw
        ? 'Draw'
        : hasWon
        ? 'You Won!'
        : 'You Lose';

    final message = isDraw
        ? 'The round ended in a draw.'
        : hasWon
        ? 'You won this round!'
        : 'Your opponent won this round.';

    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.surface,
            shape: _dialogShape(context),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: Dimens.sixteen,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _navigator.pop();
                      onConfirm?.call();
                    },
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // ROOM CLOSED
  // ===========================================================================

  static Future<void> showRoomClosed({required String reason}) {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.surface,
            shape: _dialogShape(context),
            title: Text(
              'Room Closed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: Dimens.sixteen,
              children: [
                Text(
                  reason,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Row(
                  spacing: Dimens.twelve,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _navigator.pop();
                          AppNavigation.goToHome();
                        },
                        child: const Text('BACK HOME'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _navigator.pop();
                          AppNavigation.replaceCreateRoom();
                        },
                        child: const Text('NEW GAME'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
          ),
        );
      },
    );
  }

  // ===========================================================================
  // GAME DISMISSED
  // ===========================================================================

  static Future<void> showGameDismissed({
    required GameDismissedResponse response,
  }) {
    final reason = response.reason;

    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.surface,
            shape: _dialogShape(context),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            icon: Icon(reason.icon, color: reason.color, size: 48),
            title: Text(
              'Game Dismissed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: reason.color,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Text(
                  reason.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _navigator.pop();
                          AppNavigation.goToHome();
                        },
                        child: const Text('BACK HOME'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _navigator.pop();
                          AppNavigation.replaceCreateRoom();
                        },
                        child: const Text('NEW GAME'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // QUIT CONFIRMATION
  // ===========================================================================

  static Future<bool> confirmQuit() async {
    final result = await showDialog<bool>(
      context: _context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quit Game?'),
          content: const Text(
            'Are you sure you want to quit the current game?',
          ),
          actions: [
            TextButton(
              onPressed: () => _navigator.pop(false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => _navigator.pop(true),
              child: const Text('QUIT'),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  static RoundedRectangleBorder _dialogShape(BuildContext context) {
    return RoundedRectangleBorder(
      borderRadius: Dimens.radius16,
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
      ),
    );
  }
}
