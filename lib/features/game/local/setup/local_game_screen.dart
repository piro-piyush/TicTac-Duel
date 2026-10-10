import 'package:tictac_duel/lib.dart';

class LocalGameScreen extends ConsumerStatefulWidget {
  const LocalGameScreen({super.key});

  @override
  ConsumerState<LocalGameScreen> createState() => _LocalGameScreenState();
}

class _LocalGameScreenState extends ConsumerState<LocalGameScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    final initialGameType = ref.read(localGameProvider).gameType;
    final initialIndex = LocalGameType.values.indexOf(initialGameType);

    _tabController = TabController(
      length: LocalGameType.values.length,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final gameType = LocalGameType.values[_tabController.index];
    final currentGameType = ref.read(localGameProvider).gameType;

    if (gameType != currentGameType) {
      ref.read(localGameProvider.notifier).setGameType(gameType);
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localGameProvider);
    final notifier = ref.read(localGameProvider.notifier);

    // Keep the tab selection synchronized with provider state changes.
    ref.listen(localGameProvider.select((state) => state.gameType), (
      previous,
      next,
    ) {
      final index = LocalGameType.values.indexOf(next);

      if (index >= 0 && _tabController.index != index) {
        _tabController.animateTo(index);
      }
    });

    return NeonBackgroundWidget(
      title: 'Local Game',
      bottomNavigationBar:
          NeonElevatedButtonWidget.icon(
                label: 'START GAME',
                icon: Icons.sports_esports_rounded,
                isLoading: state.isStarting,
                onPressed: notifier.startGame,
              )
              .animate()
              .fadeIn(
                delay: AnimationConstants.staggerMedium,
                duration: AnimationConstants.medium,
              )
              .slideY(
                begin: AnimationConstants.slideSmall,
                end: 0,
                delay: AnimationConstants.staggerMedium,
                duration: AnimationConstants.medium,
                curve: AnimationConstants.defaultCurve,
              ),
      bottom: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicatorPadding: Dimens.edgeInsets24_0,
        indicator: BoxDecoration(
          color: AppColors.neonPurple.withValues(alpha: 0.12),
          borderRadius: Dimens.radius16,
          border: Border.all(
            color: AppColors.neonPurple.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),

        labelColor: AppColors.neonPurple,
        unselectedLabelColor: AppColors.disabled,
        labelStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontWeight: FontWeight.w600),
        splashBorderRadius: Dimens.radius16,
        tabs: LocalGameType.values
            .map(
              (type) => Tab(
                height: Dimens.eighty,
                text: type.displayName,
                icon: Icon(type.icon),
              ),
            )
            .toList(),
      ),

      child: LocalGameContentWidget(
        gameType: state.gameType,
        selectedSymbol: state.selectedSymbol,
        selectedTheme: state.selectedTheme,
        selectedMaxRounds: state.selectedMaxRounds,
        selectedDifficulty: state.selectedDifficulty,
        onSymbolChanged: notifier.setSelectedSymbol,
        onThemeChanged: notifier.setSelectedTheme,
        onRoundsChanged: notifier.setSelectedMaxRounds,
        onDifficultyChanged: notifier.setSelectedDifficulty,
      ),
    );
  }
}
