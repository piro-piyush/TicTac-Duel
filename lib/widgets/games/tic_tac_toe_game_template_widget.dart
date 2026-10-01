import 'package:tictac_duel/lib.dart';

class TicTacToeGameScreen extends StatelessWidget {
  const TicTacToeGameScreen({
    super.key,
    required this.title,
    required this.currentRound,
    required this.maxRounds,
    required this.player,
    required this.status,
    required this.theme,
    required this.child,
    this.bottomNavigationBar,
  });

  final String title;
  final int currentRound;
  final int maxRounds;
  final PlayerModel player;
  final String status;
  final RoomTheme theme;
  final Widget child;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 380;

        return NeonBackgroundWidget(
          title: title,
          needScroll: false,

          // AppBar
          bottom: TicTacToeRoundWidget(
            compact: isCompact,
            currentRound: currentRound,
            maxRounds: maxRounds,
          ),

          // Bottom game status
          bottomNavigationBar: bottomNavigationBar ??
              TicTacToeStatusWidget(
                compact: isCompact,
                player: player,
                status: status,
                theme: theme,
              ),

          // Game content
          child: child,
        );
      },
    );
  }
}