import 'package:tictac_duel/lib.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'HELP',
      child: Column(
        spacing: Dimens.thirtySix,
        children: [
          Column(
            spacing: Dimens.twentyEight,
            children: [
              const HeaderSectionWidget(
                title: 'NEED A HAND?',
                subtitle: 'Everything you need to dominate the board.',
                icon: Icons.help_outline_rounded,
              ),

              HowToPlayWidget(),

              OnlineDuelsWidget(),

              QuickTipsWidget(),
            ],
          ),

          FooterCardWidget(),
        ],
      ),
    );
  }
}
