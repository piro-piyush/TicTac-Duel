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
      spacing: Dimens.sixteen,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          spacing: Dimens.eight,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitleWidget(title: 'ROOM THEME'),
            Row(
              spacing: Dimens.ten,
              children: RoomTheme.values.map(_buildThemeChip).toList(),
            ),
          ],
        ),
        _buildThemePreview(),
      ],
    );
  }

  Widget _buildThemeChip(RoomTheme theme) {
    final isSelected = selectedTheme == theme;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onThemeChanged(theme),
          borderRadius: Dimens.radius14,
          splashColor: theme.primary.withValues(alpha: 0.08),
          highlightColor: theme.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: Dimens.edgeInsets14,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.primary.withValues(alpha: 0.09)
                  : AppColors.surface,
              borderRadius: Dimens.radius14,
              border: Border.all(
                color: isSelected
                    ? theme.primary.withValues(alpha: 0.75)
                    : AppColors.border,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.10),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              spacing: Dimens.eight,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        theme.name,
                        style: TextStyle(
                          color: isSelected
                              ? theme.primary
                              : AppColors.textPrimary,
                          fontSize: 12,
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
                          : SizedBox(
                              key: ValueKey('unselected'),
                              width: Dimens.iconSm,
                              height: Dimens.iconSm,
                            ),
                    ),
                  ],
                ),
                Text(
                  theme.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
                Row(
                  spacing: Dimens.six,
                  children: [
                    _buildThemeDot(theme.primary),
                    _buildThemeDot(theme.secondary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemePreview() {
    final theme = selectedTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: Dimens.edgeInsets16,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Dimens.radius18,
        border: Border.all(color: theme.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        spacing: Dimens.sixteen,
        children: [
          _buildMiniBoard(theme),
          Expanded(
            child: Column(
              spacing: Dimens.eight,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR ARENA',
                  style: TextStyle(
                    color: theme.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                ),
                Text(
                  theme.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  theme.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Row(
                  spacing: Dimens.six,
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      size: Dimens.iconXs,
                      color: theme.secondary,
                    ),
                    Text(
                      'Theme preview',
                      style: TextStyle(
                        color: theme.secondary,
                        fontSize: 10,
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
      width: Dimens.ninetySix,
      height: Dimens.ninetySix,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: GameConstants.themePreviewSymbols.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: GameConstants.boardSize,
          crossAxisSpacing: Dimens.four,
          mainAxisSpacing: Dimens.four,
        ),
        itemBuilder: (context, index) {
          final symbol = GameConstants.themePreviewSymbols[index];

          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: Dimens.radius6,
              border: Border.all(color: theme.primary.withValues(alpha: 0.07)),
            ),
            child: Center(
              child: symbol == null
                  ? null
                  : Text(
                      symbol.value.toString().toUpperCase(),
                      style: TextStyle(
                        color: symbol == PlayerSymbol.x
                            ? theme.primary
                            : theme.secondary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeDot(Color color) {
    return Container(
      width: Dimens.ten,
      height: Dimens.ten,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 6),
        ],
      ),
    );
  }
}
