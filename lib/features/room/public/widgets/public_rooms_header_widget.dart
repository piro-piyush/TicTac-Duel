import 'package:tictac_duel/lib.dart';

class PublicRoomsHeaderWidget extends StatelessWidget {
  const PublicRoomsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CHOOSE YOUR', style: textTheme.labelSmall),
        const SizedBox(height: Dimens.six),
        Text('NEXT ROOM', style: textTheme.headlineSmall),
        const SizedBox(height: Dimens.twelve),
        Text(
          'Browse available rooms and join a duel.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
