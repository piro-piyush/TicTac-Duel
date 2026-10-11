import 'package:tictac_duel/lib.dart';

class PublicRoomsScreen extends ConsumerWidget {
  const PublicRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(publicRoomsProvider);
    final notifier = ref.read(publicRoomsProvider.notifier);

    return NeonBackgroundWidget(
      title: 'Public Rooms',
      padding: Dimens.edgeInsets10_4,
      child: RefreshIndicator(
        onRefresh: notifier.refreshRooms,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Dimens.twenty,
            children: [
              const RoomHeaderWidget(
                    eyebrow: 'CHOOSE YOUR',
                    title: 'NEXT ROOM',
                    description: 'Browse available rooms and join a duel.',
                  )
                  .animate()
                  .fadeIn(duration: AnimationConstants.medium)
                  .slideY(
                    begin: AnimationConstants.slideSmall,
                    end: 0,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),

              if (state.isFetchingRooms)
                const PublicRoomsLoadingWidget().animate().fadeIn(
                  duration: AnimationConstants.fast,
                )
              else if (state.rooms.isEmpty)
                const EmptyPublicRoomsWidget()
                    .animate()
                    .fadeIn(duration: AnimationConstants.medium)
                    .scale(
                      begin: const Offset(
                        AnimationConstants.scaleSmall,
                        AnimationConstants.scaleSmall,
                      ),
                      end: const Offset(
                        AnimationConstants.scaleNormal,
                        AnimationConstants.scaleNormal,
                      ),
                      duration: AnimationConstants.medium,
                      curve: AnimationConstants.defaultCurve,
                    )
              else
                Column(
                  spacing: Dimens.twelve,
                  children: [
                    for (var index = 0; index < state.rooms.length; index++)
                      PublicRoomCardWidget(
                            key: ValueKey(state.rooms[index].roomCode),
                            room: state.rooms[index],
                            onJoin: () =>
                                notifier.showJoinDialog(state.rooms[index]),
                          )
                          .animate()
                          .fadeIn(
                            delay: AnimationConstants.staggerShort * index,
                            duration: AnimationConstants.medium,
                          )
                          .slideY(
                            begin: AnimationConstants.slideSmall,
                            end: 0,
                            delay: AnimationConstants.staggerShort * index,
                            duration: AnimationConstants.medium,
                            curve: AnimationConstants.defaultCurve,
                          ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
