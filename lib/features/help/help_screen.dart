import 'package:tictac_duel/lib.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'HELP',
      child: Column(
        spacing: Dimens.thirty,
        children: [
          Column(
            spacing: Dimens.twentyEight,
            children: [
              const HeaderSectionWidget(
                    title: 'NEED A HAND?',
                    subtitle: 'Everything you need to dominate the board.',
                    icon: Icons.help_outline_rounded,
                  )
                  .animate()
                  .fadeIn(duration: AnimationConstants.medium)
                  .slideY(
                    begin: -AnimationConstants.slideMedium,
                    end: 0,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),

              const HowToPlayWidget()
                  .animate()
                  .fadeIn(
                    delay: AnimationConstants.staggerShort,
                    duration: AnimationConstants.medium,
                  )
                  .slideY(
                    begin: AnimationConstants.slideMedium,
                    end: 0,
                    delay: AnimationConstants.staggerShort,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),

              const OnlineDuelsWidget()
                  .animate()
                  .fadeIn(
                    delay: AnimationConstants.staggerMedium,
                    duration: AnimationConstants.medium,
                  )
                  .slideY(
                    begin: AnimationConstants.slideMedium,
                    end: 0,
                    delay: AnimationConstants.staggerMedium,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),

              const QuickTipsWidget()
                  .animate()
                  .fadeIn(
                    delay: AnimationConstants.staggerLong,
                    duration: AnimationConstants.medium,
                  )
                  .slideY(
                    begin: AnimationConstants.slideMedium,
                    end: 0,
                    delay: AnimationConstants.staggerLong,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),
            ],
          ),

          const FooterCardWidget()
              .animate()
              .fadeIn(
                delay: AnimationConstants.extraLong,
                duration: AnimationConstants.medium,
              )
              .slideY(
                begin: AnimationConstants.slideLarge,
                end: 0,
                delay: AnimationConstants.extraLong,
                duration: AnimationConstants.medium,
                curve: AnimationConstants.defaultCurve,
              ),
        ],
      ),
    );
  }
}
