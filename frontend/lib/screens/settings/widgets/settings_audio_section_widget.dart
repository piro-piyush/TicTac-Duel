import 'package:tictac_duel/lib.dart';

class SettingsAudioSectionWidget extends StatelessWidget {
  final bool musicEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final ValueChanged<bool> onMusicChanged;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<bool> onVibrationChanged;

  const SettingsAudioSectionWidget({
    super.key,
    required this.musicEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.onMusicChanged,
    required this.onSoundChanged,
    required this.onVibrationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionTitleAndOptionsWidget(
      title: 'Audio & Feedback',
      children: [
        SectionTileWidget.withSwitch(
          icon: Icons.music_note_rounded,
          title: 'Background Music',
          subtitle: 'Play music while you play',
          value: musicEnabled,
          color: Themes.neonPurple,
          onChanged: (value) => onMusicChanged(value),
        ),
        SectionTileWidget.withSwitch(
          icon: Icons.volume_up_rounded,
          title: 'Sound Effects',
          subtitle: 'Play sounds during the game',
          value: soundEnabled,
          color: Themes.neonCyan,
          onChanged: (value) => onSoundChanged(value),
        ),
        SectionTileWidget.withSwitch(
          icon: Icons.vibration_rounded,
          title: 'Vibration',
          subtitle: 'Vibrate when making a move',
          value: vibrationEnabled,
          color: Themes.neonPink,
          onChanged: (value) => onVibrationChanged(value),
        ),
      ],
    );
  }
}
