import 'package:tictac_duel/lib.dart';

class SectionTitleWidget extends StatelessWidget {
  const SectionTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2),
  );
}
