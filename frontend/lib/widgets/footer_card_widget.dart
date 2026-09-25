import 'package:tictac_duel/lib.dart';

class FooterCardWidget extends StatelessWidget {
  const FooterCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: Dimens.thirtyTwo,
          height: Dimens.two,
          decoration: BoxDecoration(
            color: Themes.neonCyan.withValues(alpha: 0.6),
            borderRadius: Dimens.radius10,
          ),
        ),
        SizedBox(height: Dimens.sixteen),
        Text(
          'Tic Tac Duel',
          style: textTheme.titleSmall?.copyWith(
            color: Themes.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: Dimens.four),
        Text(
          'YOUR MOVE. YOUR GLORY.',
          style: textTheme.labelSmall?.copyWith(
            color: Themes.textSecondary.withValues(alpha: 0.65),
            letterSpacing: 1.6,
          ),
        ),
        SizedBox(height: Dimens.eight),
        Text(
          'v1.0.0',
          style: textTheme.labelSmall?.copyWith(
            color: Themes.textSecondary.withValues(alpha: 0.35),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
