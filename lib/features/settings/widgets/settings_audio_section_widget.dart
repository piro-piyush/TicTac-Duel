import 'package:flutter/foundation.dart';
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

  bool get _supportsVibration {
    if (kIsWeb) return false;

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
  }

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
          color: AppColors.neonPurple,
          onChanged: onMusicChanged,
        ),
        SectionTileWidget.withSwitch(
          icon: Icons.volume_up_rounded,
          title: 'Sound Effects',
          subtitle: 'Play sounds during the game',
          value: soundEnabled,
          color: AppColors.neonCyan,
          onChanged: onSoundChanged,
        ),
        if (_supportsVibration)
          SectionTileWidget.withSwitch(
            icon: Icons.vibration_rounded,
            title: 'Vibration',
            subtitle: 'Vibrate when making a move',
            value: vibrationEnabled,
            color: AppColors.neonPink,
            onChanged: onVibrationChanged,
          ),
      ],
    );
  }
}
