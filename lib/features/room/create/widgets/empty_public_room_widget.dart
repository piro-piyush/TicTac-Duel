import 'package:tictac_duel/lib.dart';

class EmptyPublicRoomWidget extends StatelessWidget {
  const EmptyPublicRoomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Dimens.edgeInsets16,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: Dimens.radius14,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: Dimens.fortyFour,
            height: Dimens.fortyFour,
            decoration: BoxDecoration(
              color: AppColors.neonCyan.withValues(alpha: 0.08),
              borderRadius: Dimens.radius12,
              border: Border.all(
                color: AppColors.neonCyan.withValues(alpha: 0.18),
              ),
            ),
            child: const Icon(
              Icons.sports_esports_outlined,
              color: AppColors.neonCyan,
              size: Dimens.iconMd,
            ),
          ),
          const SizedBox(width: Dimens.twelve),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.four,
              children: [
                Text(
                  'No public rooms',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: Dimens.twelve,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Create a room and wait for an opponent.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: Dimens.ten,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
