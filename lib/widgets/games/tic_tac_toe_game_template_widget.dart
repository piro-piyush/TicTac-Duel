import 'package:tictac_duel/lib.dart';

class TicTacToeGameTemplateWidget extends StatelessWidget {
  const TicTacToeGameTemplateWidget({
    super.key,
    this.title,
    required this.currentRound,
    required this.maxRounds,
    required this.player,
    required this.theme,
    required this.child,
    required this.isOnline,
    required this.isMe,
    this.actions,
    required this.showGameStatus,
     this.floatingActionButton,
  });

  final String? title;
  final int currentRound;
  final int maxRounds;
  final PlayerModel player;
  final RoomTheme theme;
  final Widget child;
  final bool isOnline;
  final bool Function(String) isMe;
  final bool showGameStatus;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 380;

        return NeonBackgroundWidget(
          title: title,
          needScroll: false,
          actions: actions,
          floatingActionButton: floatingActionButton,
          bottom: showGameStatus
              ? TicTacToeRoundWidget(
                  compact: isCompact,
                  currentRound: currentRound,
                  maxRounds: maxRounds,
                )
              : null,

          // bottomNavigationBar: showGameStatus
          //     ? Center(
          //         child: TicTacToeStatusWidget(
          //           compact: isCompact,
          //           player: player,
          //           isOnline: isOnline,
          //           theme: theme,
          //           isMe: isMe,
          //         ),
          //       )
          //     : null,

          child: child,
        );
      },
    );
  }
}
