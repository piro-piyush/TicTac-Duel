import 'package:tictac_duel/lib.dart';

class EmptyPublicRoomsWidget extends StatelessWidget {
  const EmptyPublicRoomsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsets32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Dimens.twelve,
        children: [
          const Icon(
            Icons.public_off_rounded,
            size: Dimens.fortyEight,
            color: AppColors.textSecondary,
          ),
          Text(
            'No Public Rooms',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'There are no open rooms right now.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
