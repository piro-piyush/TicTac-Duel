import 'package:tictac_duel/lib.dart';

class QuickTipsWidget extends StatelessWidget {
  const QuickTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionTitleAndOptionsWidget(
      title: 'QUICK TIPS',
      titleIcon: Icons.tips_and_updates_outlined,
      children: [
        SectionTileWidget(
          icon: Icons.visibility_rounded,
          color: AppColors.neonCyan,
          title: 'Watch the Board',
          subtitle:
              'Look for your opponent’s winning moves and block them '
              'before they complete a line.',
        ),
        SectionTileWidget(
          icon: Icons.my_location_rounded,
          color: AppColors.neonPurple,
          title: 'Take the Center',
          subtitle:
              'The center connects to more winning lines, making it '
              'a valuable position to control.',
        ),
        SectionTileWidget(
          icon: Icons.bolt_rounded,
          color: AppColors.neonPink,
          title: 'Set Up a Win',
          subtitle:
              'Create two possible winning moves at once to make it '
              'harder for your opponent to block both.',
        ),
      ],
    );
  }
}
