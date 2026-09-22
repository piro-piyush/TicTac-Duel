import 'package:tictac_duel/lib.dart';

class ReadyIndicatorWidget extends StatelessWidget {
  const ReadyIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Themes.neonGreen,
            boxShadow: [BoxShadow(color: Themes.neonGreen, blurRadius: 8)],
          ),
        ),
        Text(
          'READY TO DUEL',
          style: TextStyle(
            color: Themes.neonGreen.withValues(alpha: 0.75),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
