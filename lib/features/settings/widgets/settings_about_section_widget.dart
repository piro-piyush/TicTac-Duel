import 'package:tictac_duel/lib.dart';

class SettingsAboutSectionWidget extends StatelessWidget {
  const SettingsAboutSectionWidget({super.key});

  static const _privacyPolicyText =
      'Tic Tac Duel does not collect, store, or transmit any personal '
      'information.\n\n'
      'The app does not require an account or personal information to play.\n\n'
      'Game-related information used during gameplay is processed locally '
      'on your device and is not collected by us.\n\n'
      'Tic Tac Duel does not use analytics, advertising, or tracking services '
      'to monitor your activity.';

  @override
  Widget build(BuildContext context) {
    return SectionTitleAndOptionsWidget(
      title: 'About',
      children: [
        SectionTileWidget.withAction(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'Tic Tac Duel • Version ${GameConstants.appVersion}',
          color: AppColors.neonCyan,
          onTap: () => _showAbout(context),
        ),
        SectionTileWidget.withAction(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'How your data is handled',
          color: AppColors.textSecondary,
          onTap: () => _showPrivacyPolicy(context),
        ),
      ],
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
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

  void _showPrivacyPolicy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: Text(
              _privacyPolicyText,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
