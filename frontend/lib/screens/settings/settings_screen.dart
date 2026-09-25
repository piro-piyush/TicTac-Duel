import 'package:tictac_duel/lib.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    return NeonBackgroundWidget(
      title: 'SETTINGS',
      child: Column(

        spacing: 32,
        children: [
          Column(
            spacing: 28,
            children: [
              const HeaderSectionWidget(
                title: 'Game Settings',
                subtitle: 'Customize your duel experience.',
                icon: Icons.settings_rounded,
              ),

              SettingsAudioSectionWidget(
                soundEnabled: musicProvider.effectsEnabled,
                musicEnabled: musicProvider.isEnabled,
                vibrationEnabled: musicProvider.vibrationEnabled,
                onSoundChanged: musicProvider.setEffectsEnabled,
                onMusicChanged: musicProvider.setMusicEnabled,
                onVibrationChanged: musicProvider.setVibrationEnabled,
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
