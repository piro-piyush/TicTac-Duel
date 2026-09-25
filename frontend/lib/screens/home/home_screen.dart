import 'package:tictac_duel/lib.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SocketService.instance.connect();
  }

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      needScroll: false,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: Dimens.defaultPadding,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogoWidget(),

                      const SizedBox(height: 22),

                      const Text(
                        'Tic Tac Duel',
                        style: TextStyle(
                          color: Themes.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        'YOUR MOVE. YOUR GLORY.',
                        style: TextStyle(
                          color: Themes.textSecondary.withValues(alpha: 0.85),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3.5,
                        ),
                      ),

                      const SizedBox(height: 48),

                      MenuButtonWidget(
                        title: 'Create Game',
                        subtitle: 'Start a new duel',
                        icon: Icons.add_rounded,
                        color: Themes.neonCyan,
                        // secondaryColor: Themes.neonPurple,
                        onTap: Routes.pushCreateRoom,
                      ),

                      const SizedBox(height: 14),

                      MenuButtonWidget(
                        title: 'Invite Friend',
                        subtitle: 'Challenge someone to play',
                        icon: Icons.person_add_alt_1_rounded,
                        color: Themes.neonPurple,
                        // secondaryColor: Themes.neonPink,
                        onTap: Routes.pushJoinRoom,
                      ),

                      const SizedBox(height: 30),

                      ReadyIndicatorWidget(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _openDummyResult(won: true),
                            icon: const Icon(Icons.emoji_events_rounded),
                          ),
                          IconButton(
                            onPressed: () => _openDummyResult(won: false),
                            icon: const Icon(
                              Icons.sentiment_dissatisfied_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                QuickActionWidget(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: Routes.pushSettings,
                ),
                QuickActionWidget(
                  icon: Icons.help_outline_rounded,
                  label: 'Help',
                  onTap: Routes.pushHelp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDummyResult({required bool won}) {
    final mySocketId = SocketService.instance.socketId;

    final room = RoomModel(
      id: won ? '222' : '333',
      code: 'ABC123',
      theme: RoomTheme.classic,
      occupancy: 2,
      maxRounds: 5,
      currentRound: 5,
      roundStatus: RoundStatus.result,
      turn: null,
      turnIndex: 0,
      boardSize: 9,
      players: [
        PlayerModel(
          name: 'Piyush',
          symbol: PlayerSymbol.x,
          socketId: mySocketId,
          points: won ? 3 : 2,
          isReady: false,
        ),
        PlayerModel(
          name: 'Alex',
          symbol: PlayerSymbol.o,
          socketId: 'opponent-socket-id',
          points: won ? 2 : 3,
          isReady: false,
        ),
      ],
    );

    context.read<RoomDataProvider>().setRoom(room);

    Routes.pushResult();
  }
}
