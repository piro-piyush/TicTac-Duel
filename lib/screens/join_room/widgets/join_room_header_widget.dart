import 'package:tictac_duel/lib.dart';

class JoinRoomHeaderWidget extends StatelessWidget {
  const JoinRoomHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('READY FOR THE', style: textTheme.labelSmall),
        SizedBox(height: Dimens.six),
        Text('NEXT DUEL?', style: textTheme.headlineSmall),
        SizedBox(height: Dimens.twelve),
        Text(
          'Enter the room code and join the battle.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
