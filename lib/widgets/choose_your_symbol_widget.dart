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
    final isCompact =
        MediaQuery.sizeOf(context).width < Dimens.smallScreenWidth;
    return Column(
      spacing: Dimens.eight,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitleWidget(title: 'CHOOSE YOUR SYMBOL'),
        Row(
          spacing: Dimens.eight,
          children: PlayerSymbol.values
              .map(
                (symbol) => Expanded(
                  child: _buildSymbolCard(
                    context,
                    symbol,
                    isCompact: isCompact,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSymbolCard(
    BuildContext context,
    PlayerSymbol symbol, {
    required bool isCompact,
  }) {
    final isSelected = selectedSymbol == symbol;
    final color = symbol.symbolColor;

    return Material(
      color: Colors.transparent,
      borderRadius: Dimens.radius16,
      child: InkWell(
        onTap: () => onSymbolChanged(symbol),
        borderRadius: Dimens.radius16,
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: isCompact ? Dimens.ninetySix : Dimens.sixtyFour,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? Dimens.six : Dimens.eight,
            // vertical: isCompact ? Dimens.six : Dimens.eight,
          ),
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
          child: isCompact
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: Dimens.four,
                  children: [
                    Icon(symbol.icon, color: color, size: Dimens.iconMd),
                    Flexible(
                      child: Text(
                        symbol.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )
              : Row(
                  spacing: Dimens.four,
                  children: [
                    Icon(symbol.icon, color: color, size: Dimens.iconMd),
                    Expanded(
                      child: Text(
                        symbol.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
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
