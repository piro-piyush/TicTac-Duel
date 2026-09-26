import 'package:tictac_duel/lib.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicProvider);

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
                soundEnabled: musicState.effectsEnabled,
                musicEnabled: musicState.isEnabled,
                vibrationEnabled: musicState.vibrationEnabled,
                onSoundChanged: (enabled) {
                  ref
                      .read(musicProvider.notifier)
                      .setEffectsEnabled(enabled);
                },
                onMusicChanged: (enabled) {
                  ref
                      .read(musicProvider.notifier)
                      .setMusicEnabled(enabled);
                },
                onVibrationChanged: (enabled) {
                  ref
                      .read(musicProvider.notifier)
                      .setVibrationEnabled(enabled);
                },
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