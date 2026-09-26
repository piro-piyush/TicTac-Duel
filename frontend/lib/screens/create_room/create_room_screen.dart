import 'package:tictac_duel/lib.dart';

class CreateRoomScreen extends GetView<RoomController> {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'Create Room',
      bottomNavigationBar: Obx(
        () => NeonElevatedButton(
          label: 'CREATE ROOM',
          icon: Icons.rocket_launch_rounded,
          isLoading: controller.isCreating,
          onPressed: controller.createRoom,
        ),
      ),
      child: CreateRoomContentWidget(
        formKey: controller.formKey,
        playerNameController: controller.playerNameController,
        playerNameFocusNode: controller.playerNameFocusNode,
        selectedSymbol: controller.selectedSymbol,
        selectedTheme: controller.selectedTheme,
        selectedMaxRounds: controller.selectedMaxRounds,
        onSymbolChanged: controller.setSelectedSymbol,
        onThemeChanged: controller.setSelectedTheme,
        onRoundsChanged: controller.setSelectedMaxRounds,
        onGenerateRandomName: controller.generateRandomName,
        rooms: RoomModel.publicRooms,
        onRefresh: controller.refreshRooms,
        onJoinRoom: (room) {
          // TODO: Join public room.
        },
      ),
    );
  }
}
