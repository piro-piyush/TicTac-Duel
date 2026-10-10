import 'package:tictac_duel/lib.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future<void>.delayed(_splashDuration);

    if (!mounted) return;

    context.goNamed(AppRoutes.settings.name);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return NeonBackgroundWidget(
      needScroll: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.twentyTwo,
          children: [
            // Animated app logo.
            const AppLogoWidget()
                .animate()
                .fadeIn(duration: AnimationConstants.medium)
                .rotate(
                  begin: AnimationConstants.logoEntranceRotation,
                  end: AnimationConstants.logoRestingRotation,
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.entranceCurve,
                )
                .scale(
                  begin: AnimationConstants.scaleBegin,
                  end: AnimationConstants.scaleEnd,
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.entranceCurve,
                ),

            // App name and tagline.
            Column(
              spacing: Dimens.eight,
              children: [
                Text(
                      GameConstants.appName,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge,
                    )
                    .animate()
                    .fadeIn(
                      delay: AnimationConstants.homeTitleDelay,
                      duration: AnimationConstants.medium,
                    )
                    .slideY(
                      begin: AnimationConstants.slideLarge,
                      end: 0,
                      delay: AnimationConstants.homeTitleDelay,
                      duration: AnimationConstants.medium,
                      curve: AnimationConstants.defaultCurve,
                    ),

                Text(
                      GameConstants.appSlogan,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall,
                    )
                    .animate()
                    .fadeIn(
                      delay: AnimationConstants.homeSloganDelay,
                      duration: AnimationConstants.medium,
                    )
                    .slideY(
                      begin: AnimationConstants.slideMedium,
                      end: 0,
                      delay: AnimationConstants.homeSloganDelay,
                      duration: AnimationConstants.medium,
                      curve: AnimationConstants.defaultCurve,
                    ),
              ],
            ),

            // Subtle loading indicator.
            const _SplashLoadingIndicator()
                .animate()
                .fadeIn(
                  delay: AnimationConstants.staggerLong,
                  duration: AnimationConstants.medium,
                )
                .slideY(
                  begin: AnimationConstants.slideSmall,
                  end: 0,
                  delay: AnimationConstants.staggerLong,
                  duration: AnimationConstants.medium,
                  curve: AnimationConstants.defaultCurve,
                ),
          ],
        ),
      ),
    );
  }
}

class _SplashLoadingIndicator extends StatelessWidget {
  const _SplashLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.twelve,
      children: [
        const SizedBox(
          width: Dimens.oneHundred,
          child: ClipRRect(
            borderRadius: Dimens.radius20,
            child: LinearProgressIndicator(
              minHeight: Dimens.four,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
            ),
          ),
        ),
        Text(
          'PREPARING YOUR DUEL',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
