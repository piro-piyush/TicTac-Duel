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

  // Temporary UI data.
  final List<_PublicRoom> _publicRooms = const [
    _PublicRoom(playerName: 'Alex', theme: RoomTheme.classic, maxRounds: 3),
    _PublicRoom(playerName: 'Shadow', theme: RoomTheme.inferno, maxRounds: 5),
    _PublicRoom(playerName: 'Nova', theme: RoomTheme.classic, maxRounds: 7),
  ];

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
      needScroll: false,
      title: 'Create Room',
      child: Stack(children: [_buildContent(), _buildCreateButton()]),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 110),
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
                setState(() {
                  _selectedSymbol = symbol;
                });
              },
            ),

            _buildRoundSelector(),

            SelectRoomThemeWidget(
              selectedTheme: _selectedTheme,
              onThemeChanged: (theme) {
                setState(() {
                  _selectedTheme = theme;
                });
              },
            ),

            _buildPublicRooms(),

            _buildRoomInfo(),
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

  Widget _buildRoundSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ROUNDS',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Themes.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Themes.border),
          ),
          child: Row(
            children: GameConstants.roundOptions.map((rounds) {
              final isSelected = rounds == _selectedMaxRounds;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMaxRounds = rounds;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Themes.neonPurple.withValues(alpha: 0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Themes.neonPurple
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      spacing: 2,
                      children: [
                        Text(
                          '$rounds',
                          style: TextStyle(
                            color: isSelected
                                ? Themes.textPrimary
                                : Themes.textSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          rounds == 1 ? 'ROUND' : 'ROUNDS',
                          style: TextStyle(
                            color: isSelected
                                ? Themes.neonPurple
                                : Themes.textSecondary,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPublicRooms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'PUBLIC ROOMS',
                style: TextStyle(
                  color: Themes.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: Refresh public rooms.
              },
              visualDensity: VisualDensity.compact,
              tooltip: 'Refresh',
              icon: const Icon(
                Icons.refresh_rounded,
                color: Themes.textSecondary,
                size: 18,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (_publicRooms.isEmpty)
          _buildEmptyPublicRooms()
        else
          Column(
            spacing: 10,
            children: _publicRooms.map((room) {
              return _buildPublicRoomCard(room);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPublicRoomCard(_PublicRoom room) {
    final themeColor = room.theme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Themes.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Themes.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: themeColor.withValues(alpha: 0.35)),
            ),
            child: Icon(
              Icons.sports_esports_rounded,
              color: themeColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.playerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Themes.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${room.theme.name}  •  '
                  '${room.maxRounds} '
                  '${room.maxRounds == 1 ? 'Round' : 'Rounds'}',
                  style: const TextStyle(
                    color: Themes.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          TextButton.icon(
            onPressed: () {
              // TODO: Join public room.
            },
            style: TextButton.styleFrom(
              foregroundColor: themeColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text(
              'JOIN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPublicRooms() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Themes.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Themes.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.sports_esports_outlined,
            color: Themes.textSecondary,
            size: 28,
          ),
          SizedBox(height: 10),
          Text(
            'No public rooms available',
            style: TextStyle(
              color: Themes.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Create a room and wait for an opponent.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Themes.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
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
        maxRounds: _selectedMaxRounds,
      );
    } catch (e) {
      LoggerUtils.error('Error creating room: $e');
    }
  }
}

class _PublicRoom {
  const _PublicRoom({
    required this.playerName,
    required this.theme,
    required this.maxRounds,
  });

  final String playerName;
  final RoomTheme theme;
  final int maxRounds;
}
