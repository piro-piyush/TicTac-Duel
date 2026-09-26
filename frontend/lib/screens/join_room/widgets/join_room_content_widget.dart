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
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController playerNameController;
  final TextEditingController roomCodeController;

  final FocusNode playerNameFocusNode;
  final FocusNode roomCodeFocusNode;

  final VoidCallback onGenerateRandomName;
  final VoidCallback onPasteCode;
  final VoidCallback onJoinRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.twentyEight,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const JoinRoomHeaderWidget(),

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

        const JoinDividerWidget(),

        NeonOutlinedButtonWidget(
          label: 'CREATE YOUR OWN ROOM',
          icon: Icons.add_rounded,
          color: AppColors.neonPurple,
          onPressed: AppNavigation.replaceCreateRoom,
        ),
      ],
    );
  }
}
