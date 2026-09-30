import 'package:tictac_duel/lib.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NeonBackgroundWidget(
      title: 'HELP',
      child: Column(
        spacing: Dimens.thirty,
        children: [
          Column(
            spacing: Dimens.twentyEight,
            children: [
              HeaderSectionWidget(
                title: 'NEED A HAND?',
                subtitle: 'Everything you need to master the board.',
                icon: Icons.help_outline_rounded,
              ),
              HowToPlayWidget(),
              GameModesWidget(),
              QuickTipsWidget(),
            ],
          ),
          FooterCardWidget(),
        ],
      ),
    );
  }
}