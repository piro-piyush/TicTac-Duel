import 'package:tictac_duel/lib.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({
    super.key,
    required this.roomTheme,
    required this.isMyTurn,
    required this.values,
    this.onCellTap,
  });

  final List<PlayerSymbol?> values;
  final RoomTheme roomTheme;
  final bool isMyTurn;
  final ValueChanged<int>? onCellTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Themes.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Themes.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: roomTheme.primary.withValues(alpha: 0.10),
              blurRadius: 32,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: roomTheme.secondary.withValues(alpha: 0.05),
              blurRadius: 18,
              spreadRadius: -2,
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: values.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return GameBoardCellWidget(
              index: index,
              values: values,
              theme: roomTheme,
              isMyTurn: isMyTurn,
              onCellTap: onCellTap,
            );
          },
        ),
      ),
    );
  }
}
