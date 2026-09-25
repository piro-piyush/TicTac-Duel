import 'package:tictac_duel/lib.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _playerNameController = TextEditingController();
  final _playerNameFocusNode = FocusNode();

  PlayerSymbol _selectedSymbol = PlayerSymbol.x;
  RoomTheme _selectedTheme = RoomTheme.classic;
  int _selectedMaxRounds = 3;

  @override
  void initState() {
    super.initState();

    _playerNameFocusNode.requestFocus();

    final roomSocket = RoomSocketService.instance;

    roomSocket.onRoomCreated((room) async {
      if (!mounted) {
        return;
      }

      context.read<MusicProvider>().lightVibration();
      context.read<RoomDataProvider>().setRoom(room);

      Routes.replaceToGame();
    });

    roomSocket.onRoomError((message) {
      if (!mounted) {
        return;
      }

      context.read<MusicProvider>().mediumVibration();

      SnackbarUtils.showError(context, 'Room error: $message');
    });
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _playerNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'Create Room',
      child: Stack(
        children: [
          CreateRoomContentWidget(
            formKey: _formKey,
            playerNameController: _playerNameController,
            playerNameFocusNode: _playerNameFocusNode,
            selectedSymbol: _selectedSymbol,
            selectedTheme: _selectedTheme,
            selectedMaxRounds: _selectedMaxRounds,
            onSymbolChanged: (symbol) {
              setState(() {
                _selectedSymbol = symbol;
              });
            },
            onThemeChanged: (theme) {
              setState(() {
                _selectedTheme = theme;
              });
            },
            onRoundsChanged: (rounds) {
              setState(() {
                _selectedMaxRounds = rounds;
              });
            },
            onGenerateRandomName: _generateRandomName,
            rooms: RoomModel.publicRooms,
            onRefresh: () {
              setState(() {});
            },
            createRoom: _createRoom,
            onJoinRoom: (room) {
              // RoomSocketService.instance.joinRoom(room.id);
            },
          ),
          // Align(
          //   alignment: AlignmentGeometry.bottomCenter,
          //   child: NeonElevatedButton(
          //     label: 'CREATE ROOM',
          //     icon: Icons.rocket_launch_rounded,
          //     onPressed: _createRoom,
          //   ),
          // ),
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

  void _createRoom() {
    try {
      if (!_formKey.currentState!.validate()) {
        _playerNameFocusNode.requestFocus();
        return;
      }

      final playerName = _playerNameController.text.trim();

      RoomSocketService.instance.createRoom(
        playerName: playerName,
        symbol: _selectedSymbol,
        theme: _selectedTheme,
        maxRounds: _selectedMaxRounds,
      );
    } catch (e) {
      LoggerUtils.error('Error creating room: $e');
    }
  }
}
