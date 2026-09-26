import 'package:tictac_duel/lib.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      createRoomProvider.select((state) => state.errorMessage),
      (_, message) {
        if (message == null || !mounted) {
          return;
        }

        SnackbarUtils.showError(context, 'Room error: $message');

        ref.read(createRoomProvider.notifier).clearError();
      },
    );

    final isCreating = ref.watch(
      createRoomProvider.select((state) => state.isCreating),
    );

    return NeonBackgroundWidget(
      title: 'Create Room',
      bottomNavigationBar: NeonElevatedButton(
        label: 'CREATE ROOM',
        icon: Icons.rocket_launch_rounded,
        onPressed: isCreating ? null : _createRoom,
      ),
      child: CreateRoomContentWidget(
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
        onJoinRoom: (room) {
          // TODO: Join public room.
        },
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
    if (!_formKey.currentState!.validate()) {
      _playerNameFocusNode.requestFocus();
      return;
    }

    ref
        .read(createRoomProvider.notifier)
        .createRoom(
          playerName: _playerNameController.text.trim(),
          symbol: _selectedSymbol,
          theme: _selectedTheme,
          maxRounds: _selectedMaxRounds,
        );
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _playerNameFocusNode.dispose();

    super.dispose();
  }
}
