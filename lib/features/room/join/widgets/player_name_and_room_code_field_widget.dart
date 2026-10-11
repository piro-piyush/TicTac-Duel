import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class PlayerNameAndRoomCodeFieldWidget extends StatelessWidget {
  const PlayerNameAndRoomCodeFieldWidget({
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
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: Column(
      spacing: Dimens.twelve,
      children: [_buildPlayerNameField(), _buildRoomCodeField()],
    ),
  );

  Widget _buildPlayerNameField() => GameTextFormFieldWidget(
    controller: playerNameController,
    focusNode: playerNameFocusNode,
    hintText: 'ENTER YOUR NAME',
    validator: ValidatorUtils.gameName,
    textCapitalization: TextCapitalization.words,
    textInputAction: TextInputAction.next,
    maxLength: GameConstants.maxPlayerNameLength,
    onFieldSubmitted: (_) {
      roomCodeFocusNode.requestFocus();
    },
    suffixIcon: IconButton(
      onPressed: onGenerateRandomName,
      tooltip: 'Random name',
      icon: const Icon(Icons.casino_outlined, color: AppColors.neonCyan),
    ),
  );

  Widget _buildRoomCodeField() => GameTextFormFieldWidget(
    controller: roomCodeController,
    focusNode: roomCodeFocusNode,
    hintText: 'ENTER CODE',
    validator: ValidatorUtils.roomCode,
    autofocus: true,
    textCapitalization: TextCapitalization.characters,
    keyboardType: TextInputType.text,
    maxLength: GameConstants.roomCodeLength,
    inputFormatters: [
      FilteringTextInputFormatter.allow(GameConstants.roomCodeCharacterPattern),
      LengthLimitingTextInputFormatter(GameConstants.roomCodeLength),
    ],
    onFieldSubmitted: (_) => onJoinRoom(),
    suffixIcon: IconButton(
      onPressed: onPasteCode,
      tooltip: 'Paste code',
      icon: const Icon(Icons.content_paste_rounded, color: AppColors.neonCyan),
    ),
  );
}
