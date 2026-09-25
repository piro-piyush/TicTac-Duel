import 'package:tictac_duel/lib.dart';

class CreateRoomHeaderWidget extends StatelessWidget {
  const CreateRoomHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('READY FOR A', style: textTheme.labelSmall),
        SizedBox(height: Dimens.six),
        Text('NEW DUEL?', style: textTheme.headlineSmall),
        SizedBox(height: Dimens.twelve),
        Text(
          'Set up your arena and challenge a rival.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
