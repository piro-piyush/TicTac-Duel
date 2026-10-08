import 'package:tictac_duel/lib.dart';

class JoinRoomContentWidget extends StatelessWidget {
  const JoinRoomContentWidget({
    super.key,
    required this.formKey,
    required this.playerNameController,
    required this.roomCodeController,
    required this.playerNameFocusNode,
    required this.roomCodeFocusNode,
    required this.onGenerateRandomName,
    required this.onPasteCode,
    required this.onJoinRoom,
    required this.onCreateRoom,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController playerNameController;
  final TextEditingController roomCodeController;

  final FocusNode playerNameFocusNode;
  final FocusNode roomCodeFocusNode;

  final VoidCallback onGenerateRandomName;
  final VoidCallback onPasteCode;
  final VoidCallback onJoinRoom;
  final VoidCallback onCreateRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.twentyEight,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RoomHeaderWidget(
          eyebrow: 'HAVE A ROOM',
          title: 'CODE?',
          description: 'Enter the room code and join the battle.',
        ),
        PlayerNameAndRoomCodeFieldWidget(
          formKey: formKey,
          playerNameController: playerNameController,
          roomCodeController: roomCodeController,
          playerNameFocusNode: playerNameFocusNode,
          roomCodeFocusNode: roomCodeFocusNode,
          onGenerateRandomName: onGenerateRandomName,
          onPasteCode: onPasteCode,
          onJoinRoom: onJoinRoom,
        ),
        const JoinRoomHintWidget(),
        const OrDividerWidget(),
        NeonOutlinedButtonWidget.icon(
          label: 'CREATE YOUR OWN ROOM',
          icon: Icons.add_rounded,
          color: AppColors.neonPurple,
          onPressed: onCreateRoom,
        ),
      ],
    );
  }
}
