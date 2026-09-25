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
    required this.onSymbolChanged,
    required this.onThemeChanged,
    required this.onRoundsChanged,
    required this.onGenerateRandomName,
    required this.rooms,
    required this.onRefresh,
    required this.onJoinRoom,
    required this.createRoom,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController playerNameController;
  final FocusNode playerNameFocusNode;

  final PlayerSymbol selectedSymbol;
  final RoomTheme selectedTheme;
  final int selectedMaxRounds;

  final ValueChanged<PlayerSymbol> onSymbolChanged;
  final ValueChanged<RoomTheme> onThemeChanged;
  final ValueChanged<int> onRoundsChanged;

  final VoidCallback onGenerateRandomName;
  final VoidCallback createRoom;

  final List<RoomModel> rooms;
  final VoidCallback onRefresh;
  final ValueChanged<RoomModel> onJoinRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.twentyEight,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CreateRoomHeaderWidget(),

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

        PublicRoomWidget(
          rooms: rooms,
          onRefresh: onRefresh,
          onJoinRoom: onJoinRoom,
        ),

        const CreateRoomInfoWidget(),
        NeonElevatedButton(
          label: 'CREATE ROOM',
          icon: Icons.rocket_launch_rounded,
          onPressed: createRoom,
        ),
      ],
    );
  }
}
