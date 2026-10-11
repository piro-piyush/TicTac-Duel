import 'package:tictac_duel/lib.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      spacing: Dimens.fourteen,
      children: [
        Expanded(child: Container(height: 1, color: AppColors.border)),
        Text('OR', style: textTheme.labelSmall),
        Expanded(child: Container(height: 1, color: AppColors.border)),
      ],
    );
  }
}
