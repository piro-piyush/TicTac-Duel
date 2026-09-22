import 'package:tictac_duel/lib.dart';

class JoinRoomHintWidget extends StatelessWidget {
  const JoinRoomHintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: Themes.textSecondary,
          size: 15,
        ),
        Text(
          'Use the 6–8 character code from your friend',
          style: TextStyle(
            color: Themes.textSecondary.withValues(alpha: 0.8),
            fontSize: 10,
          ),
        ),
      ],
    );;
  }
}
