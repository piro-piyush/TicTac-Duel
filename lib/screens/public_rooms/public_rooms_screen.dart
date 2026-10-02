import 'package:tictac_duel/lib.dart';

class PublicRoomsScreen extends GetView<PublicRoomsController> {
  const PublicRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'Public Rooms',
      needScroll: false,
      padding: Dimens.edgeInsets10_4,
      child: RefreshIndicator(
        onRefresh: controller.refreshRooms,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Dimens.twenty,
            children: [
              // Public Rooms
              const RoomHeaderWidget(
                eyebrow: 'CHOOSE YOUR',
                title: 'NEXT ROOM',
                description: 'Browse available rooms and join a duel.',
              ),
              Obx(() {
                if (controller.isFetchingRooms) {
                  return const PublicRoomsLoadingWidget();
                }

                if (controller.rooms.isEmpty) {
                  return const EmptyPublicRoomsWidget();
                }

                return Column(
                  spacing: Dimens.twelve,
                  children: controller.rooms
                      .map(
                        (room) => PublicRoomCardWidget(
                          room: room,
                          onJoin: () => controller.joinPublicRoom(room),
                        ),
                      )
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
