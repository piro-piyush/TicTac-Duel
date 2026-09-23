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

  @override
  void initState() {
    super.initState();

    _playerNameFocusNode.requestFocus();

    final roomSocket = RoomSocketService.instance;

    roomSocket.onRoomCreated((room) async {
      if (!mounted) {
        return;
      }

      MusicAndFeedbackService.instance.mediumVibration();

      SnackbarUtils.showSuccess(
        context,
        'Room created',
      );

      context.read<RoomDataProvider>().setRoom(room);

      Routes.replaceGame();
    });

    roomSocket.onRoomError((message) {
      if (!mounted) {
        return;
      }

      MusicAndFeedbackService.instance.mediumVibration();

      SnackbarUtils.showError(
        context,
        'Room error: $message',
      );
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
      needScroll: false,
      title: 'Create Room',
      child: Stack(children: [_buildContent(), _buildCreateButton()]),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: Dimens.defaultPadding,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 28,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreateRoomHeaderWidget(),

            _buildPlayerNameField(),

            ChooseYourSymbolWidget(
              selectedSymbol: _selectedSymbol,
              onSymbolChanged: (symbol) {
                setState(() => _selectedSymbol = symbol);
              },
            ),

            SelectRoomThemeWidget(
              selectedTheme: _selectedTheme,
              onThemeChanged: (theme) {
                setState(() => _selectedTheme = theme);
              },
            ),

            _buildRoomInfo(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR NAME',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _playerNameController,
          focusNode: _playerNameFocusNode,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          maxLength: 20,
          validator: ValidatorUtils.gameName,
          style: const TextStyle(
            color: Themes.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: 'ENTER YOUR NAME',
            hintStyle: TextStyle(
              color: Themes.textSecondary.withValues(alpha: 0.4),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            suffixIcon: IconButton(
              onPressed: _generateRandomName,
              tooltip: 'Random name',
              icon: const Icon(
                Icons.casino_outlined,
                color: Themes.neonPurple,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Themes.card,
            border: _buildInputBorder(),
            enabledBorder: _buildInputBorder(),
            focusedBorder: _buildInputBorder(
              color: Themes.neonPurple,
              width: 1.5,
            ),
            errorBorder: _buildInputBorder(color: Themes.neonPink),
            focusedErrorBorder: _buildInputBorder(
              color: Themes.neonPink,
              width: 1.5,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildInputBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color ?? Themes.border, width: width),
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

  Widget _buildRoomInfo() {
    return Column(
      spacing: 14,
      children: [
        _buildInfoRow(
          icon: Icons.flash_on_rounded,
          title: 'Quick matchmaking',
          subtitle: 'Get ready for your next duel.',
        ),
        _buildInfoRow(
          icon: Icons.shield_outlined,
          title: 'Your room, your rules',
          subtitle: 'Invite a friend and start playing.',
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      spacing: 12,
      children: [
        Icon(icon, color: Themes.textSecondary, size: 20),
        Expanded(
          child: Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Themes.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Themes.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 12,
      child: NeonElevatedButton(
        label: 'CREATE ROOM',
        icon: Icons.rocket_launch_rounded,
        onPressed: _createRoom,
      ),
    );
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
      );
    } catch (e) {
      LoggerUtils.error('Error creating room: $e');
    }
  }
}
