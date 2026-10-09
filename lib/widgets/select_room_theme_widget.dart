import 'package:tictac_duel/lib.dart';

class SelectRoomThemeWidget extends StatelessWidget {
  const SelectRoomThemeWidget({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  final RoomTheme selectedTheme;
  final ValueChanged<RoomTheme> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.twelve,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitleWidget(title: 'ROOM THEME'),
        Row(
          spacing: Dimens.eight,
          children: RoomTheme.values
              .map((theme) => Expanded(child: _buildThemeCard(theme)))
              .toList(),
        ),
        _buildThemePreview(),
      ],
    );
  }

  Widget _buildThemeCard(RoomTheme theme) {
    final isSelected = selectedTheme == theme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onThemeChanged(theme),
        borderRadius: Dimens.radius12,
        splashColor: theme.primary.withValues(alpha: 0.08),
        highlightColor: theme.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: Dimens.fiftySix,
          padding: Dimens.edgeInsets12_8,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.primary.withValues(alpha: 0.08)
                : AppColors.surface,
            borderRadius: Dimens.radius14,
            border: Border.all(
              color: isSelected
                  ? theme.primary.withValues(alpha: 0.65)
                  : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  theme.displayName,
                  style: TextStyle(
                    color: isSelected ? theme.primary : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isSelected
                    ? Icon(
                  Icons.check_circle_rounded,
                  key: const ValueKey('selected'),
                  color: theme.primary,
                  size: Dimens.iconSm,
                )
                    : const SizedBox(
                  key: ValueKey('unselected'),
                  width: Dimens.iconSm,
                  height: Dimens.iconSm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemePreview() {
    final theme = selectedTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: Dimens.edgeInsets12,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Dimens.radius16,
        border: Border.all(color: theme.primary.withValues(alpha: 0.22)),
      ),
      child: Row(
        spacing: Dimens.twelve,
        children: [
          _buildMiniBoard(theme),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.four,
              children: [
                Text(
                  theme.displayName,
                  style: TextStyle(
                    color: theme.primary,
                    fontSize: Dimens.sixteen,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  theme.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: Dimens.twelve,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: Dimens.two),
                Row(
                  spacing: Dimens.six,
                  children: [
                    _buildThemeDot(theme.primary),
                    Text(
                      'Primary',
                      style: TextStyle(
                        color: theme.primary,
                        fontSize: Dimens.twelve,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _buildThemeDot(theme.secondary),
                    Text(
                      'Secondary',
                      style: TextStyle(
                        color: theme.secondary,
                        fontSize: Dimens.twelve,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBoard(RoomTheme theme) {
    return SizedBox(
      width: Dimens.eightyEight,
      height: Dimens.eightyEight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: GameConstants.themePreviewSymbols.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: GameConstants.boardSize,
          crossAxisSpacing: Dimens.four,
          mainAxisSpacing: Dimens.four,
        ),
        itemBuilder: (context, index) {
          final symbol = GameConstants.themePreviewSymbols[index];

          return DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: Dimens.radius6,
              border: Border.all(color: theme.primary.withValues(alpha: 0.08)),
            ),
            child: symbol == null
                ? null
                : Center(
              child: Icon(
                symbol.icon,
                color: symbol == PlayerSymbol.x
                    ? theme.primary
                    : theme.secondary,
                size: Dimens.iconMd,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeDot(Color color) {
    return Container(
      width: Dimens.eight,
      height: Dimens.eight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 5),
        ],
      ),
    );
  }
}