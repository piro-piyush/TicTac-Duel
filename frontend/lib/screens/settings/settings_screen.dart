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
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const SettingsHeaderWidget(),
          const SizedBox(height: 28),

          SettingsAudioSectionWidget(
            soundEnabled: _soundEnabled,
            musicEnabled: _musicEnabled,
            vibrationEnabled: _vibrationEnabled,
            onSoundChanged: (value) => setState(() => _soundEnabled = value),
            onMusicChanged: (value) => setState(() => _musicEnabled = value),
            onVibrationChanged: (value) =>
                setState(() => _vibrationEnabled = value),
          ),

          const SizedBox(height: 28),

          SettingsAboutSectionWidget(),

          const SizedBox(height: 40),

          const FooterCardWidget(),
        ],
      ),
    );
  }
}
