import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _roomCodeController = TextEditingController();
  final _focusNode = FocusNode();
  final _playerNameController = TextEditingController();
  final _playerNameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _roomCodeController.dispose();
    _playerNameController.dispose();

    _focusNode.dispose();
    _playerNameFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _playerNameFocusNode.requestFocus();
    RoomSocketService.instance.onRoomJoined((room) {
      Provider.of<RoomDataProvider>(context, listen: false).setRoom(room);
      Routes.replaceToGame();
    });
    RoomSocketService.instance.onRoomError((room) {
      SnackbarUtils.showError(context, 'Room error: $room');
    });
  }

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      needScroll: false,
      title: 'JOIN ROOM',
      child: Stack(
        children: [
          JoinRoomContentWidget(
            formKey: _formKey,
            playerNameController: _playerNameController,
            roomCodeController: _roomCodeController,
            playerNameFocusNode: _playerNameFocusNode,
            roomCodeFocusNode: _focusNode,
            onGenerateRandomName: _generateRandomName,
            onPasteCode: _pasteCode,
            onJoinRoom: _joinRoom,
          ),
          RoomJoinButtonWidget(joinRoom: _joinRoom),
        ],
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

    final playerName = _playerNameController.text.trim();
    final roomCode = _roomCodeController.text.trim().toUpperCase();

    RoomSocketService.instance.joinRoom(
      playerName: playerName,
      roomCode: roomCode,
    );
  }
}
