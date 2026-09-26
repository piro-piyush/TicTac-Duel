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
          color: AppColors.neonCyan,
          onTap: () => _showAbout(context),
        ),
        SectionTileWidget.withAction(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'How your data is handled',
          color: AppColors.textSecondary,
          onTap: Routes.pushPrivacyPolicy,
        ),
      ],
    );
  }

  void _showAbout(BuildContext context) {
    return showAboutDialog(
      context: context,
      applicationName: GameConstants.appName,
      applicationVersion: 'Version ${GameConstants.appVersion}',
      applicationIcon: const Icon(
        Icons.grid_3x3_rounded,
        color: AppColors.neonCyan,
      ),
      children: [
        Text(
          GameConstants.appDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
