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
        const SectionTitleWidget(title: 'CHOOSE YOUR SYMBOL'),
        Row(
          spacing: Dimens.eight,
          children: PlayerSymbol.values
              .map((symbol) => Expanded(child: _buildSymbolCard(symbol)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSymbolCard(PlayerSymbol symbol) {
    final isSelected = selectedSymbol == symbol;
    final color = symbol.symbolColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSymbolChanged(symbol),
        borderRadius: Dimens.radius16,
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.twelve),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.08)
                : AppColors.surface,
            borderRadius: Dimens.radius16,
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.7)
                  : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.10),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(symbol.icon, color: color, size: Dimens.iconXl),
              const SizedBox(width: Dimens.ten),
              Expanded(
                child: Text(
                  symbol.displayName,
                  style: Get.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
                  size: Dimens.iconMd,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
