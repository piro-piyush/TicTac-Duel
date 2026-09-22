import 'package:tictac_duel/lib.dart';

class JoinRoomHeaderWidget extends StatelessWidget {
  const JoinRoomHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'READY FOR THE',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: 13,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'NEXT DUEL?',
          style: TextStyle(
            color: Themes.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Enter the room code and join the battle.',
          style: TextStyle(
            color: Themes.textSecondary.withValues(alpha: 0.9),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
