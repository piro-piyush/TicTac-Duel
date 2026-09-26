import 'package:tictac_duel/lib.dart';

class FooterCardWidget extends StatelessWidget {
  const FooterCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: Dimens.four,
      children: [
        Container(
          width: Dimens.thirtyTwo,
          height: Dimens.two,
          margin: Dimens.edgeInsetsB6,
          decoration: BoxDecoration(
            color: Themes.neonCyan.withValues(alpha: 0.6),
            borderRadius: Dimens.radius10,
          ),
        ),
        Text(GameConstants.appName, style: textTheme.titleLarge),
        Text(GameConstants.appSlogan, style: textTheme.labelSmall),
        Text('v${GameConstants.appVersion}', style: textTheme.labelSmall),
      ],
    );
  }
}
