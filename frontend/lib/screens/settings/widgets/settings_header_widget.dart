import 'package:tictac_duel/lib.dart';

class SettingsHeaderWidget extends StatelessWidget {
  const SettingsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Themes.neonCyan.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Themes.neonCyan.withValues(alpha: 0.18)),
          ),
          child: const Icon(
            Icons.settings_rounded,
            color: Themes.neonCyan,
            size: 21,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Game Settings',
                style: TextStyle(
                  color: Themes.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Customize your duel experience.',
                style: TextStyle(color: Themes.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
