import 'package:tictac_duel/lib.dart';

class SettingsScreen extends GetView<MusicController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'SETTINGS',
      child: Column(
        spacing: Dimens.thirtySix,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: Dimens.twentyEight,
            mainAxisSize: MainAxisSize.min,
            children: [
              const HeaderSectionWidget(
                title: 'Game Settings',
                subtitle: 'Customize your duel experience.',
                icon: Icons.settings_rounded,
              ),

              Obx(
                () => SettingsAudioSectionWidget(
                  soundEnabled: controller.effectsEnabled,
                  musicEnabled: controller.isEnabled,
                  vibrationEnabled: controller.vibrationEnabled,
                  onSoundChanged: controller.setEffectsEnabled,
                  onMusicChanged: controller.setEnabled,
                  onVibrationChanged: controller.setVibrationEnabled,
                ),
              ),

              const SettingsAboutSectionWidget(),
            ],
          ),

          const FooterCardWidget(),
        ],
      ),
    );
  }
}
