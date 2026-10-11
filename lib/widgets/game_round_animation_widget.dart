import 'package:tictac_duel/lib.dart';

class GameRoundAnimationWidget extends StatelessWidget {
  const GameRoundAnimationWidget({
    super.key,
    required this.showRoundAnimation,
    required this.animatedRound,
  });

  final bool showRoundAnimation;
  final int animatedRound;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 650),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final scale = Tween<double>(begin: 0.82, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );

        final slide =
            Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(scale: scale, child: child),
          ),
        );
      },
      child: showRoundAnimation
          ? Text(
              'ROUND $animatedRound',
              key: ValueKey(animatedRound),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 3.5,
                color: Colors.white,
                shadows: [
                  Shadow(blurRadius: 6, color: AppColors.neonPurple),
                  Shadow(blurRadius: 18, color: AppColors.neonPurple),
                ],
              ),
            )
          : const SizedBox.shrink(),
    ),
  );
}
