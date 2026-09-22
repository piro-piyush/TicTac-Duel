import 'package:tictac_duel/lib.dart';

class HelpTipCardWidget extends StatelessWidget {
  const HelpTipCardWidget({super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.color,
  });

  final String number;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Themes.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Themes.border),
      ),
      child: Row(
        children: [
          Text(
            number,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 30, color: color.withValues(alpha: 0.25)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Themes.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Themes.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
