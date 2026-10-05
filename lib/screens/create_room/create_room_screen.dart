import 'package:tictac_duel/lib.dart';

class CreateRoomScreen extends GetView<RoomController> {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NeonBackgroundWidget(
        title: 'Create Room',
        bottomNavigationBar: NeonElevatedButton(
          label: 'CREATE ROOM',
          icon: Icons.rocket_launch_rounded,
          isLoading: controller.isCreating,
          onPressed: controller.createRoom,
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
          isRoomPrivate: controller.isRoomPrivate,
          onPrivateRoomChanged: controller.setIsPrivateRoom,
        ),
      ),
    );
  }
}
