import 'package:tictac_duel/lib.dart';

class RoomPrivacyWidget extends StatelessWidget {
  const RoomPrivacyWidget({
    super.key,
    required this.isPrivate,
    required this.onChanged,
  });

  final bool isPrivate;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.card,
      borderRadius: Dimens.radius14,
      clipBehavior: Clip.antiAlias,
      child: SwitchListTile(
        value: isPrivate,
        onChanged: onChanged,
        contentPadding: Dimens.edgeInsets14,
        secondary: Icon(
          Icons.lock_rounded,
          color: AppColors.neonPink,
          size: Dimens.iconMd,
        ),
        title: Text(
          'Private Room',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          isPrivate
              ? 'Only players with the room code can join.'
              : 'Anyone can discover and join this room.',
          style: textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
        activeThumbColor: AppColors.neonPink,
        activeTrackColor: AppColors.neonPink.withValues(alpha: 0.25),
      ),
    );
  }
}
