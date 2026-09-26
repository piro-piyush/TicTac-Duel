import 'package:tictac_duel/lib.dart';

class QuickTipsWidget extends StatelessWidget {
  const QuickTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionTitleAndOptionsWidget(
      title: 'QUICK TIPS',
      titleIcon: Icons.tips_and_updates_outlined,
      children: [
        SectionTileWidget(
          icon: Icons.visibility_rounded,
          title: 'Think Ahead',
          subtitle: 'Watch your opponent’s possible winning moves.',
          color: AppColors.neonCyan,
        ),
        SectionTileWidget(
          icon: Icons.my_location_rounded,
          title: 'Control the Center',
          subtitle: 'The center can be part of multiple winning combinations.',
          color: AppColors.neonPurple,
        ),
        SectionTileWidget(
          icon: Icons.bolt_rounded,
          title: 'Create Pressure',
          subtitle: 'Try to create multiple possible winning moves at once.',
          color: AppColors.neonPink,
        ),
      ],
    );
  }
}
