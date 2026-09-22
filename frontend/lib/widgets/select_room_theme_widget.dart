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
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitleWidget(title: 'ROOM THEME'),
            Row(
              spacing: 10,
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
          borderRadius: BorderRadius.circular(14),
          splashColor: theme.primary.withValues(alpha: 0.08),
          highlightColor: theme.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.primary.withValues(alpha: 0.09)
                  : Themes.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? theme.primary.withValues(alpha: 0.75)
                    : Themes.border,
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
              spacing: 9,
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
                              : Themes.textPrimary,
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
                              size: 16,
                            )
                          : const SizedBox(
                              key: ValueKey('unselected'),
                              width: 16,
                              height: 16,
                            ),
                    ),
                  ],
                ),
                Text(
                  theme.subtitle,
                  style: const TextStyle(
                    color: Themes.textSecondary,
                    fontSize: 9,
                  ),
                ),
                Row(
                  spacing: 5,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        spacing: 16,
        children: [
          _buildMiniBoard(theme),
          Expanded(
            child: Column(
              spacing: 7,
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
                    color: Themes.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  theme.subtitle,
                  style: const TextStyle(
                    color: Themes.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      size: 13,
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
    const symbols = ['X', '', 'O', '', 'X', '', 'O', '', ''];

    return SizedBox(
      width: 94,
      height: 94,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: symbols.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          final symbol = symbols[index];

          return Container(
            decoration: BoxDecoration(
              color: Themes.card,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: theme.primary.withValues(alpha: 0.07)),
            ),
            child: Center(
              child: symbol.isEmpty
                  ? null
                  : Text(
                      symbol,
                      style: TextStyle(
                        color: symbol == 'X' ? theme.primary : theme.secondary,
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
      width: 9,
      height: 9,
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
