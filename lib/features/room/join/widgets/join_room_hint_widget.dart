import 'package:tictac_duel/lib.dart';

class JoinRoomHintWidget extends StatelessWidget {
  const JoinRoomHintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.eight,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.textSecondary,
          size: Dimens.iconSm,
        ),
        Flexible(
          child: Text(
            'Use the 6–8 character code from your friend',
            textAlign: TextAlign.center,
            softWrap: true,
            style: textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
