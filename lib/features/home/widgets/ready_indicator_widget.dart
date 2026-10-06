import 'package:tictac_duel/lib.dart';

class ReadyIndicatorWidget extends StatelessWidget {
  const ReadyIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.ten,
      children: [
        Container(
          width: Dimens.six,
          height: Dimens.six,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.neonGreen,
            boxShadow: [BoxShadow(color: AppColors.neonGreen, blurRadius: 8)],
          ),
        ),
        Text(
          'READY TO DUEL',
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.neonGreen.withValues(alpha: 0.75),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
