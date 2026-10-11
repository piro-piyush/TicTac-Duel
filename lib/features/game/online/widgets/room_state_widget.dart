import 'package:tictac_duel/lib.dart';

enum RoomState { connecting, notFound, playerNotFound, error }

class RoomStateWidget extends StatelessWidget {
  const RoomStateWidget._({
    super.key,
    required this.state,
    this.message,
    this.onRetry,
  });

  const RoomStateWidget.connecting({Key? key})
    : this._(key: key, state: RoomState.connecting);

  const RoomStateWidget.notFound({Key? key})
    : this._(key: key, state: RoomState.notFound);

  const RoomStateWidget.playerNotFound({Key? key})
    : this._(key: key, state: RoomState.playerNotFound);

  const RoomStateWidget.error({
    Key? key,
    String? message,
    VoidCallback? onRetry,
  }) : this._(
         key: key,
         state: RoomState.error,
         message: message,
         onRetry: onRetry,
       );

  final RoomState state;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final config = _RoomStateConfig.fromState(state, message: message);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: Dimens.icon2Xl),
          const SizedBox(height: Dimens.sixteen),
          Text(
            config.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.six),
          Text(
            config.message,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: Dimens.twenty),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: TextButton.styleFrom(foregroundColor: config.color),
            ),
          ],
        ],
      ),
    );
  }
}

class _RoomStateConfig {
  const _RoomStateConfig({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color color;

  factory _RoomStateConfig.fromState(RoomState state, {String? message}) {
    switch (state) {
      case RoomState.connecting:
        return const _RoomStateConfig(
          icon: Icons.wifi_tethering_rounded,
          title: 'Connecting to Room',
          message: 'Joining the game. Please wait...',
          color: AppColors.neonCyan,
        );

      case RoomState.notFound:
        return const _RoomStateConfig(
          icon: Icons.meeting_room_outlined,
          title: 'Room Not Found',
          message: 'This room may have expired or no longer exists.',
          color: AppColors.neonPink,
        );

      case RoomState.playerNotFound:
        return const _RoomStateConfig(
          icon: Icons.person_off_outlined,
          title: 'Player Not Found',
          message: 'You are not a member of this room.',
          color: AppColors.neonPink,
        );

      case RoomState.error:
        return _RoomStateConfig(
          icon: Icons.error_outline_rounded,
          title: 'Something Went Wrong',
          message: message ?? 'Unable to connect to the room.',
          color: AppColors.neonPink,
        );
    }
  }
}
