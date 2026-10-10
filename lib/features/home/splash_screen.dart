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

    context.goNamed(AppRoutes.home.name);
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
                ,

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
                      delay: const Duration(milliseconds: 250),
                      duration: AnimationConstants.medium,
                    )
                    .slideY(
                      begin: AnimationConstants.slideLarge,
                      end: 0,
                      delay: const Duration(milliseconds: 250),
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
                      delay: const Duration(milliseconds: 400),
                      duration: AnimationConstants.medium,
                    )
                    .slideY(
                      begin: AnimationConstants.slideMedium,
                      end: 0,
                      delay: const Duration(milliseconds: 400),
                      duration: AnimationConstants.medium,
                      curve: AnimationConstants.defaultCurve,
                    ),
              ],
            ),

            // Subtle loading indicator.
            const _SplashLoadingIndicator().animate().fadeIn(
              delay: const Duration(milliseconds: 500),
              duration: AnimationConstants.medium,
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
        SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Color(0x1FFFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
            ),
          ),
        ),
        Text(
          'PREPARING YOUR DUEL',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.75),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
