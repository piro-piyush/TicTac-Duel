import 'package:tictac_duel/lib.dart';

class RoundCardWidget extends StatelessWidget {
  const RoundCardWidget({
    super.key,
    required this.rounds,
    required this.isSelected,
    required this.onRoundChanged,
  });

  final int rounds;
  final bool isSelected;
  final ValueChanged<int> onRoundChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onRoundChanged(rounds),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: isSelected
                ? Themes.neonPurple.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Themes.neonPurple : Colors.transparent,
            ),
          ),
          child: Column(
            spacing: 2,
            children: [
              Text(
                '$rounds',
                style: TextStyle(
                  color: isSelected ? Themes.textPrimary : Themes.textSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                rounds == 1 ? 'ROUND' : 'ROUNDS',
                style: TextStyle(
                  color: isSelected ? Themes.neonPurple : Themes.textSecondary,
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
  }
}
