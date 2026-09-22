import 'package:tictac_duel/lib.dart';

class SettingsAboutSectionWidget extends StatelessWidget {
  const SettingsAboutSectionWidget({super.key});

  static const _version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return SectionTitleAndOptionsWidget(
      title: 'About',
      children: [
        SectionTileWidget.withAction(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'Tic Tac Duel • Version $_version',
          color: Themes.neonCyan,
          onTap: () => _showAbout(context),
        ),
        SectionTileWidget.withAction(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'How your data is handled',
          color: Themes.textSecondary,
          onTap: () => _showPrivacyPolicy(context),
        ),
      ],
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Tic Tac Duel',
      applicationVersion: _version,
      applicationIcon: const Icon(
        Icons.grid_3x3_rounded,
        color: Themes.neonCyan,
        size: 32,
      ),
      children: const [
        Text(
          'A simple multiplayer Tic Tac Toe experience.',
          style: TextStyle(color: Themes.textSecondary, height: 1.4),
        ),
      ],
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    // TODO: Navigate to privacy policy.
  }
}
