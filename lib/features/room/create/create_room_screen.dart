import 'package:tictac_duel/lib.dart';

class CreateRoomScreen extends ConsumerWidget {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createRoomProvider);
    final notifier = ref.read(createRoomProvider.notifier);

    return NeonBackgroundWidget(
      title: 'Create Room',
      bottomNavigationBar: NeonElevatedButtonWidget.icon(
        label: 'CREATE ROOM',
        icon: Icons.rocket_launch_rounded,
        isLoading: state.isCreating,
        onPressed: notifier.createRoom,
      ),
      child: CreateRoomContentWidget(
        formKey: notifier.createFormKey,
        playerNameController: notifier.playerNameController,
        playerNameFocusNode: notifier.playerNameFocusNode,
        selectedSymbol: state.selectedSymbol,
        selectedTheme: state.selectedTheme,
        selectedMaxRounds: state.selectedMaxRounds,
        isRoomPrivate: state.isRoomPrivate,
        onSymbolChanged: notifier.setSelectedSymbol,
        onThemeChanged: notifier.setSelectedTheme,
        onRoundsChanged: notifier.setSelectedMaxRounds,
        onPrivateRoomChanged: notifier.setIsPrivateRoom,
        onGenerateRandomName: notifier.generateRandomName,
        onBrowsePublicRooms: ref.read(appNavigationProvider).replacePublicRooms,
      ),
    );
  }
}
