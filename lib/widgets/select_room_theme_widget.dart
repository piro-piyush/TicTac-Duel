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
    final isCompact =
        MediaQuery.sizeOf(context).width < Dimens.smallScreenWidth;
    return Column(
      spacing: Dimens.twelve,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitleWidget(title: 'ROOM THEME'),
        Row(
          spacing: Dimens.eight,
          children: RoomTheme.values
              .map(
                (theme) => Expanded(
                  child: _buildThemeCard(theme, isCompact: isCompact),
                ),
              )
              .toList(),
        ),
        _buildThemePreview(isCompact: isCompact),
      ],
    );
  }

  Widget _buildThemeCard(RoomTheme theme, {required bool isCompact}) {
    final isSelected = selectedTheme == theme;

    return Material(
      color: Colors.transparent,
      borderRadius: Dimens.radius12,
      child: InkWell(
        onTap: () => onThemeChanged(theme),
        borderRadius: Dimens.radius12,
        splashColor: theme.primary.withValues(alpha: 0.08),
        highlightColor: theme.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: AnimationConstants.fast,
          height: isCompact ? 64 : Dimens.fiftySix,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? Dimens.four : Dimens.eight,
            vertical: isCompact ? Dimens.eight : 0,
          ),
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
          child: isCompact
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: Dimens.four,
                  children: [
                    Flexible(
                      child: Text(
                        theme.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? theme.primary
                              : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? theme.primary : AppColors.disabled,
                      size: Dimens.iconSm,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        theme.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: isSelected
                              ? theme.primary
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimens.four),
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? theme.primary : AppColors.disabled,
                      size: Dimens.iconSm,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildThemePreview({required bool isCompact}) {
    final theme = selectedTheme;

    return AnimatedContainer(
      duration: AnimationConstants.fast,
      padding: Dimens.edgeInsets12,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Dimens.radius16,
        border: Border.all(color: theme.primary.withValues(alpha: 0.22)),
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Dimens.twelve,
              children: [
                Center(child: _buildMiniBoard(theme)),
                _buildThemeDetails(theme, isCompact: true),
              ],
            )
          : Row(
              spacing: Dimens.twelve,
              children: [
                _buildMiniBoard(theme),
                Expanded(child: _buildThemeDetails(theme)),
              ],
            ),
    );
  }

  Widget _buildThemeDetails(RoomTheme theme, {bool isCompact = false}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.four,
        children: [
          Text(
            theme.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.primary,
              fontSize: Dimens.sixteen,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            theme.subtitle,
            maxLines: isCompact ? 3 : 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: Dimens.twelve,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Dimens.two),
          Wrap(
            spacing: Dimens.twelve,
            runSpacing: Dimens.eight,
            children: [
              _buildThemeColorLabel(theme.primary, 'Primary'),
              _buildThemeColorLabel(theme.secondary, 'Secondary'),
            ],
          ),
        ],
      );

  Widget _buildThemeColorLabel(Color color, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: Dimens.six,
    children: [
      _buildThemeDot(color),
      Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: Dimens.twelve,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  Widget _buildMiniBoard(RoomTheme theme) => SizedBox(
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

  Widget _buildThemeDot(Color color) => Container(
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
