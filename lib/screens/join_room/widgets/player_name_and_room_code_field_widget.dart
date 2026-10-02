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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: formKey,
      child: Column(
        spacing: Dimens.twenty,
        children: [
          GameTextFormFieldWidget(
            controller: playerNameController,
            focusNode: playerNameFocusNode,
            hintText: 'ENTER YOUR NAME',
            validator: ValidatorUtils.gameName,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            maxLength: 20,
            onFieldSubmitted: (_) {
              roomCodeFocusNode.requestFocus();
            },
            suffixIcon: IconButton(
              onPressed: onGenerateRandomName,
              tooltip: 'Random name',
              icon: const Icon(
                Icons.casino_outlined,
                color: AppColors.neonPurple,
                size: 20,
              ),
            ),
          ),
          GameTextFormFieldWidget(
            controller: roomCodeController,
            focusNode: roomCodeFocusNode,
            hintText: 'ENTER CODE',
            validator: ValidatorUtils.roomCode,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            maxLength: 8,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9]'),
              ),
            ],
            onChanged: (value) {
              final formatted = value.toUpperCase();

              if (formatted != value) {
                roomCodeController.value =
                    roomCodeController.value.copyWith(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
              }
            },
            onFieldSubmitted: (_) => onJoinRoom(),
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 5,
            ),
            focusedBorderColor: AppColors.neonCyan,
            suffixIcon: IconButton(
              onPressed: onPasteCode,
              tooltip: 'Paste code',
              icon: const Icon(
                Icons.content_paste_rounded,
                color: AppColors.neonCyan,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}