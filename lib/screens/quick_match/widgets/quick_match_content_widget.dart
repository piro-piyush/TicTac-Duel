import 'package:tictac_duel/lib.dart';

class QuickMatchContentWidget extends StatelessWidget {
  const QuickMatchContentWidget({
    super.key,
    required this.onOnlinePressed,
    required this.onComputerPressed,
  });

  final VoidCallback onOnlinePressed;
  final VoidCallback onComputerPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.eight,
      children: [
        SectionTitleWidget(title: 'Choose your opponent'),

        QuickMatchOptionWidget(
          icon: Icons.public_rounded,
          title: 'ONLINE',
          subtitle: 'Play against another player in real-time.',
          buttonLabel: 'PLAY ONLINE',
          onPressed: onOnlinePressed,
        ),

        SizedBox(height: Dimens.spaceBtwSections),

        QuickMatchOptionWidget(
          icon: Icons.smart_toy_rounded,
          title: 'COMPUTER',
          subtitle: 'Challenge the CPU and play offline.',
          buttonLabel: 'PLAY COMPUTER',
          onPressed: onComputerPressed,
        ),
      ],
    );
  }
}
