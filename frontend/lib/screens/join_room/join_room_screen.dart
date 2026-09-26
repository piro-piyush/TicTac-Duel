import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class JoinRoomScreen extends ConsumerStatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  ConsumerState<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends ConsumerState<JoinRoomScreen> {
  final _roomCodeController = TextEditingController();
  final _focusNode = FocusNode();
  final _playerNameController = TextEditingController();
  final _playerNameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _playerNameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _roomCodeController.dispose();
    _playerNameController.dispose();

    _focusNode.dispose();
    _playerNameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      joinRoomProvider.select((state) => state.errorMessage),
      (_, message) {
        if (message == null || !mounted) {
          return;
        }

        SnackbarUtils.showError(context, 'Room error: $message');

        ref.read(joinRoomProvider.notifier).clearError();
      },
    );

    final isJoining = ref.watch(
      joinRoomProvider.select((state) => state.isJoining),
    );

    return NeonBackgroundWidget(
      needScroll: false,
      title: 'JOIN ROOM',
      bottomNavigationBar: NeonElevatedButton(
        label: 'JOIN DUEL',
        icon: Icons.sports_esports_rounded,
        onPressed: isJoining ? null : _joinRoom,
      ),
      child: JoinRoomContentWidget(
        formKey: _formKey,
        playerNameController: _playerNameController,
        roomCodeController: _roomCodeController,
        playerNameFocusNode: _playerNameFocusNode,
        roomCodeFocusNode: _focusNode,
        onGenerateRandomName: _generateRandomName,
        onPasteCode: _pasteCode,
        onJoinRoom: _joinRoom,
      ),
    );
  }

  void _generateRandomName() {
    _playerNameController.text = GameNameUtils.random();

    _playerNameController.selection = TextSelection.collapsed(
      offset: _playerNameController.text.length,
    );

    _playerNameFocusNode.requestFocus();

    _formKey.currentState?.validate();

    setState(() {});
  }

  Future<void> _pasteCode() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);

    final code = data?.text?.trim().toUpperCase();

    if (code == null || code.isEmpty) {
      return;
    }

    _roomCodeController.text = code.length > 8 ? code.substring(0, 8) : code;

    _focusNode.requestFocus();

    setState(() {});
  }

  void _joinRoom() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref
        .read(joinRoomProvider.notifier)
        .joinRoom(
          playerName: _playerNameController.text.trim(),
          roomCode: _roomCodeController.text.trim().toUpperCase(),
        );
  }
}
