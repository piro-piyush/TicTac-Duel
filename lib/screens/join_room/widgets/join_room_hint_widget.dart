import 'package:tictac_duel/lib.dart';

class JoinRoomHintWidget extends StatelessWidget {
  const JoinRoomHintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Dimens.eight,
      children: [
        Icon(
          Icons.info_outline_rounded,
          color: AppColors.textSecondary,
          size: Dimens.iconSm,
        ),
        Text(
          'Use the 6–8 character code from your friend',
          style: textTheme.labelSmall,
        ),
      ],
    );
  }
}
