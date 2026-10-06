import 'package:tictac_duel/lib.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

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

              SettingsAudioSectionWidget(
                soundEnabled: audioState.effectsEnabled,
                musicEnabled: audioState.isEnabled,
                vibrationEnabled: audioState.vibrationEnabled,
                onSoundChanged: audioNotifier.setEffectsEnabled,
                onMusicChanged: audioNotifier.setEnabled,
                onVibrationChanged: audioNotifier.setVibrationEnabled,
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