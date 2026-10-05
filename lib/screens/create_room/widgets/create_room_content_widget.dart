import 'package:tictac_duel/lib.dart';

class CreateRoomContentWidget extends StatelessWidget {
  const CreateRoomContentWidget({
    super.key,
    required this.formKey,
    required this.playerNameController,
    required this.playerNameFocusNode,
    required this.selectedSymbol,
    required this.selectedTheme,
    required this.selectedMaxRounds,
    required this.isRoomPrivate,
    required this.onSymbolChanged,
    required this.onThemeChanged,
    required this.onRoundsChanged,
    required this.onPrivateRoomChanged,
    required this.onGenerateRandomName,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController playerNameController;
  final FocusNode playerNameFocusNode;

  final PlayerSymbol selectedSymbol;
  final RoomTheme selectedTheme;
  final int selectedMaxRounds;
  final bool isRoomPrivate;

  final ValueChanged<PlayerSymbol> onSymbolChanged;
  final ValueChanged<RoomTheme> onThemeChanged;
  final ValueChanged<int> onRoundsChanged;
  final ValueChanged<bool> onPrivateRoomChanged;

  final VoidCallback onGenerateRandomName;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.twentyEight,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create Room
        const RoomHeaderWidget(
          eyebrow: 'READY FOR A',
          title: 'NEW DUEL?',
          description: 'Set up your room and challenge a rival.',
        ),

        PlayerNameWidget(
          playerNameController: playerNameController,
          playerNameFocusNode: playerNameFocusNode,
          onPressed: onGenerateRandomName,
          formKey: formKey,
        ),

        ChooseYourSymbolWidget(
          selectedSymbol: selectedSymbol,
          onSymbolChanged: onSymbolChanged,
        ),

        RoundSelectorWidget(
          selectedRounds: selectedMaxRounds,
          onRoundChanged: onRoundsChanged,
        ),

        SelectRoomThemeWidget(
          selectedTheme: selectedTheme,
          onThemeChanged: onThemeChanged,
        ),

        SectionTileWidget.withSwitch(
          icon: Icons.lock_rounded,
          title: 'Private Room',
          subtitle: isRoomPrivate
              ? 'Only players with the room code can join.'
              : 'Anyone can discover and join this room.',
          color: AppColors.neonPink,
          value: isRoomPrivate,
          onChanged: onPrivateRoomChanged,
        ),

        const CreateRoomInfoWidget(),
        const OrDividerWidget(),

        const NeonOutlinedButtonWidget(
          label: 'BROWSE PUBLIC ROOMS',
          icon: Icons.public_rounded,
          onPressed: AppNavigation.replacePublicRooms,
        ),
      ],
    );
  }
}
