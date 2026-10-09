import 'package:tictac_duel/lib.dart';

class JoinRoomScreen extends ConsumerWidget {
  const JoinRoomScreen({super.key, this.roomCode});

  final String? roomCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(joinRoomProvider(roomCode));
    final notifier = ref.read(joinRoomProvider(roomCode).notifier);

    return NeonBackgroundWidget(
      title: 'JOIN ROOM',
      bottomNavigationBar:
          NeonElevatedButtonWidget.icon(
                label: 'JOIN DUEL',
                icon: Icons.sports_esports_rounded,
                isLoading: state.isJoining,
                onPressed: notifier.joinRoom,
              )
              .animate()
              .fadeIn(
                delay: AnimationConstants.staggerMedium,
                duration: AnimationConstants.medium,
              )
              .slideY(
                begin: AnimationConstants.slideSmall,
                end: 0,
                delay: AnimationConstants.staggerMedium,
                duration: AnimationConstants.medium,
                curve: AnimationConstants.defaultCurve,
              ),
      child: JoinRoomContentWidget(
        formKey: notifier.joinFormKey,
        playerNameController: notifier.playerNameController,
        roomCodeController: notifier.roomCodeController,
        playerNameFocusNode: notifier.playerNameFocusNode,
        roomCodeFocusNode: notifier.roomCodeFocusNode,
        onGenerateRandomName: notifier.generateRandomName,
        onPasteCode: notifier.pasteRoomCode,
        onJoinRoom: notifier.joinRoom,
        onCreateRoom: ref.read(appNavigationProvider).replaceCreateRoom,
      ),
    );
  }
}
