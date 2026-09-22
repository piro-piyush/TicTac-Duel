import 'package:tictac_duel/lib.dart';

class FooterCardWidget extends StatelessWidget {
  const FooterCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 2,
          decoration: BoxDecoration(
            color: Themes.neonCyan.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tic Tac Duel',
          style: TextStyle(
            color: Themes.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'YOUR MOVE. YOUR GLORY.',
          style: TextStyle(
            color: Themes.textSecondary.withValues(alpha: 0.65),
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'v1.0.0',
          style: TextStyle(
            color: Themes.textSecondary.withValues(alpha: 0.35),
            fontSize: 8,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
