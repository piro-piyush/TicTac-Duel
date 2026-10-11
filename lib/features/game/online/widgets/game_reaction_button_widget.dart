import 'package:tictac_duel/lib.dart';

class GameReactionButtonWidget extends ConsumerWidget {
  const GameReactionButtonWidget({
    super.key,
    required this.showReactionButton,
    required this.onSendReaction,
  });

  final bool showReactionButton;
  final ValueChanged<GameReaction> onSendReaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!showReactionButton) return const SizedBox.shrink();

    final gameDialog = ref.read(gameDialogProvider);

    return FloatingActionButton(
      onPressed: () => _showReactionPicker(gameDialog),
      tooltip: 'Send reaction',
      child: const Icon(Icons.emoji_emotions_rounded),
    );
  }

  Future<void> _showReactionPicker(GameDialogUtils gameDialog) async {
    final reaction = await gameDialog.showBottomSheet<GameReaction>(
      builder: (_) => const GameReactionBottomSheetWidget(),
    );

    if (reaction != null) {
      onSendReaction(reaction);
    }
  }
}
