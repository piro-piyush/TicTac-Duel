import 'package:tictac_duel/lib.dart';

class RoomHeaderWidget extends StatelessWidget {
  const RoomHeaderWidget({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: textTheme.labelSmall),
        const SizedBox(height: Dimens.six),
        Text(title, style: textTheme.headlineSmall),
        const SizedBox(height: Dimens.twelve),
        Text(description, style: textTheme.bodyMedium),
      ],
    );
  }
}
