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
              ),
              if (state.isFetchingRooms)
                const PublicRoomsLoadingWidget()
              else
              if (state.rooms.isEmpty)
                const EmptyPublicRoomsWidget()
              else
                Column(
                  spacing: Dimens.twelve,
                  children: state.rooms
                      .map(
                        (room) => PublicRoomCardWidget(
                          room: room,
                          onJoin: () => notifier.showJoinDialog(room),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
