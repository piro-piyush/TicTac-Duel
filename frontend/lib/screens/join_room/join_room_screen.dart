import 'package:tictac_duel/lib.dart';

class JoinRoomScreen extends GetView<RoomController> {
  const JoinRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'JOIN ROOM',
      bottomNavigationBar: Obx(
        () => NeonElevatedButton(
          label: 'JOIN DUEL',
          icon: Icons.sports_esports_rounded,
          isLoading: controller.isJoining,
          onPressed: controller.joinRoom,
        ),
      ),
      child: JoinRoomContentWidget(
        formKey: controller.formKey,
        playerNameController: controller.playerNameController,
        roomCodeController: controller.roomCodeController,
        playerNameFocusNode: controller.playerNameFocusNode,
        roomCodeFocusNode: controller.roomCodeFocusNode,
        onGenerateRandomName: controller.generateRandomName,
        onPasteCode: controller.pasteCode,
        onJoinRoom: controller.joinRoom,
        onJoinPublicRoom: controller.joinPublicRoom,
        onRefresh: controller.refreshRooms,
        rooms: controller.rooms,
      ),
    );
  }
}
