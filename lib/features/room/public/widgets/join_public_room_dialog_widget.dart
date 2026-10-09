import 'package:tictac_duel/lib.dart';

class JoinPublicRoomDialogWidget extends StatefulWidget {
  const JoinPublicRoomDialogWidget({super.key});

  @override
  State<JoinPublicRoomDialogWidget> createState() =>
      _JoinPublicRoomDialogWidgetState();
}

class _JoinPublicRoomDialogWidgetState
    extends State<JoinPublicRoomDialogWidget> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController playerNameController;
  late final FocusNode playerNameFocusNode;

  @override
  void initState() {
    super.initState();
    playerNameController = TextEditingController();
    playerNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    playerNameController.dispose();
    playerNameFocusNode.dispose();
    super.dispose();
  }

  void _validateAndJoin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.pop(playerNameController.text.trim());
    }
  }

  void _generateRandomName() {
    final name = GameNameUtils.random();

    playerNameController
      ..text = name
      ..selection = TextSelection.collapsed(offset: name.length);

    playerNameFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('JOIN THE DUEL'),
      content: Form(
        key: _formKey,
        child: GameTextFormFieldWidget(
          controller: playerNameController,
          focusNode: playerNameFocusNode,
          hintText: 'ENTER YOUR NAME',
          validator: ValidatorUtils.gameName,
          textCapitalization: TextCapitalization.words,
          maxLength: GameConstants.maxPlayerNameLength,
          onFieldSubmitted: (_) => _validateAndJoin(),
          suffixIcon: IconButton(
            onPressed: _generateRandomName,
            tooltip: 'Random name',
            icon: const Icon(
              Icons.casino_outlined,
              color: AppColors.neonPurple,
            ),
          ),
        ),
      ),
      actions: [
        NeonTextButtonWidget(
          onPressed: () => context.pop(),
          label: 'CANCEL',
          isSmall: true,
        ),
        NeonElevatedButtonWidget(
          onPressed: _validateAndJoin,
          label: 'JOIN',
          isSmall: true,
        ),
      ],
    );
  }
}
