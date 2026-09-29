import 'package:tictac_duel/lib.dart';

class ChooseYourSymbolWidget extends StatelessWidget {
  const ChooseYourSymbolWidget({
    super.key,
    required this.selectedSymbol,
    required this.onSymbolChanged,
  });

  final PlayerSymbol selectedSymbol;
  final ValueChanged<PlayerSymbol> onSymbolChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.eight,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitleWidget(
          title: 'CHOOSE YOUR SYMBOL',
        ),
        Row(
          spacing: Dimens.twelve,
          children: [
            Expanded(
              child: _buildSymbolCard(
                symbol: PlayerSymbol.x,
                color: AppColors.neonCyan,
              ),
            ),
            Expanded(
              child: _buildSymbolCard(
                symbol: PlayerSymbol.o,
                color: AppColors.neonPink,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSymbolCard({
    required PlayerSymbol symbol,
    required Color color,
  }) {
    final isSelected = selectedSymbol == symbol;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSymbolChanged(symbol),
        borderRadius: BorderRadius.circular(18),
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.10)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.8)
                  : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ]
                : null,
          ),
          child: Column(
            spacing: 9,
            children: [
              Icon(
                symbol == PlayerSymbol.x
                    ? Icons.close_rounded
                    : Icons.circle_outlined,
                color: color,
                size: 46,
              ),
              Text(
                symbol.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  key: ValueKey(isSelected),
                  color: isSelected ? color : AppColors.disabled,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}