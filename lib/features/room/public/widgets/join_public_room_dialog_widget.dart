import 'package:tictac_duel/lib.dart';

class JoinPublicRoomDialogWidget extends StatelessWidget {
  const JoinPublicRoomDialogWidget({
    super.key,
    required this.playerNameController,
    required this.playerNameFocusNode,
    required this.onGenerateRandomName,
    required this.onJoin,
    required this.onCancel,
  });

  final TextEditingController playerNameController;
  final FocusNode playerNameFocusNode;
  final VoidCallback onGenerateRandomName;
  final VoidCallback onJoin;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('JOIN THE DUEL'),
      content: GameTextFormFieldWidget(
        controller: playerNameController,
        focusNode: playerNameFocusNode,
        hintText: 'ENTER YOUR NAME',
        validator: ValidatorUtils.gameName,
        textCapitalization: TextCapitalization.words,
        maxLength: GameConstants.maxPlayerNameLength,
        onFieldSubmitted: (_) => onJoin(),
        suffixIcon: IconButton(
          onPressed: onGenerateRandomName,
          tooltip: 'Random name',
          icon: const Icon(Icons.casino_outlined, color: AppColors.neonPurple),
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('CANCEL')),
        FilledButton(onPressed: onJoin, child: const Text('JOIN')),
      ],
    );
  }
}
