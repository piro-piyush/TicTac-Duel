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
          TextFormField(
            controller: playerNameController,
            focusNode: playerNameFocusNode,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            maxLength: 20,
            validator: ValidatorUtils.gameName,
            onFieldSubmitted: (_) {
              roomCodeFocusNode.requestFocus();
            },
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            decoration: _buildInputDecoration(
              hintText: 'ENTER YOUR NAME',
              focusedColor: AppColors.neonPurple,
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
          ),
          TextFormField(
            controller: roomCodeController,
            focusNode: roomCodeFocusNode,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            maxLength: 8,
            validator: ValidatorUtils.roomCode,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            onChanged: (value) {
              final formatted = value.toUpperCase();

              if (formatted != value) {
                roomCodeController.value = roomCodeController.value.copyWith(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
            onFieldSubmitted: (_) => onJoinRoom(),
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 5,
            ),
            decoration: _buildInputDecoration(
              hintText: 'ENTER CODE',
              focusedColor: AppColors.neonCyan,
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
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required Color focusedColor,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      counterText: '',
      hintStyle: TextStyle(
        color: AppColors.textSecondary.withValues(alpha: 0.55),
        fontSize: Dimens.fontXs,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusMd),
        borderSide: BorderSide(color: focusedColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusMd),
        borderSide: const BorderSide(color: AppColors.neonPink),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusMd),
        borderSide: const BorderSide(color: AppColors.neonPink, width: 1.4),
      ),
    );
  }
}
