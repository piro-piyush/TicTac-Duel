import 'package:tictac_duel/lib.dart';

class SettingsAboutSectionWidget extends ConsumerWidget {
  const SettingsAboutSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameDialogUtils = ref.read(gameDialogProvider);

    return SectionTitleAndOptionsWidget(
      title: 'About',
      children: [
        SectionTileWidget.withAction(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'Tic Tac Duel • Version ${GameConstants.appVersion}',
          color: AppColors.neonCyan,
          onTap: gameDialogUtils.showAbout,
        ),
        SectionTileWidget.withAction(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'How your data is handled',
          color: AppColors.textSecondary,
          onTap: gameDialogUtils.showPrivacyPolicy,
        ),
      ],
    );
  }
}
