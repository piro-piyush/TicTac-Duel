import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class QuickTipsWidget extends StatelessWidget {
  const QuickTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 12,
      children: [
        HelpSectionTileWidget(
          icon: Icons.tips_and_updates_outlined,
          title: 'QUICK TIPS',
          color: Themes.neonPink,
        ),

        Column(
          spacing: 10,
          children: [
            HelpTipCardWidget(
              number: '01',
              title: 'Think Ahead',
              description: 'Watch your opponent’s possible winning moves.',
              color: Themes.neonCyan,
            ),

            HelpTipCardWidget(
              number: '02',
              title: 'Control the Center',
              description:
                  'The center can be part of multiple winning combinations.',
              color: Themes.neonPurple,
            ),

            HelpTipCardWidget(
              number: '03',
              title: 'Create Pressure',
              description:
                  'Try to create multiple possible winning moves at once.',
              color: Themes.neonPink,
            ),
          ],
        ),
      ],
    );
  }
}
