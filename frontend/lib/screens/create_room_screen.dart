import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  PlayerSymbol _selectedSymbol = PlayerSymbol.x;
  RoomTheme _selectedTheme = RoomTheme.classic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeonBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Stack(children: [_buildContent(), _buildCreateButton()]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Themes.textPrimary,
            ),
          ),
          const Expanded(
            child: Text(
              'CREATE ROOM',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Themes.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 100),
      child: Column(
        spacing: 28,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CreateRoomHeaderWidget(),

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Creating ${_selectedTheme.name} room as '
          '${_selectedSymbol.name}...',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
