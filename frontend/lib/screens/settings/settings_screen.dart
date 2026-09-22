import 'package:tictac_duel/lib.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
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
                soundEnabled: _soundEnabled,
                musicEnabled: _musicEnabled,
                vibrationEnabled: _vibrationEnabled,
                onSoundChanged: (value) =>
                    setState(() => _soundEnabled = value),
                onMusicChanged: (value) =>
                    setState(() => _musicEnabled = value),
                onVibrationChanged: (value) =>
                    setState(() => _vibrationEnabled = value),
              ),

              SettingsAboutSectionWidget(),
            ],
          ),

          FooterCardWidget(),
        ],
      ),
    );
  }
}
