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
                  )
                  .animate()
                  .fadeIn(duration: AnimationConstants.medium)
                  .slideY(
                    begin: -AnimationConstants.slideMedium,
                    end: 0,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),

              SettingsAudioSectionWidget(
                    soundEnabled: audioState.effectsEnabled,
                    musicEnabled: audioState.isEnabled,
                    vibrationEnabled: audioState.vibrationEnabled,
                    onSoundChanged: audioNotifier.setEffectsEnabled,
                    onMusicChanged: audioNotifier.setEnabled,
                    onVibrationChanged: audioNotifier.setVibrationEnabled,
                  )
                  .animate()
                  .fadeIn(
                    delay: AnimationConstants.staggerShort,
                    duration: AnimationConstants.medium,
                  )
                  .slideY(
                    begin: AnimationConstants.slideMedium,
                    end: 0,
                    delay: AnimationConstants.staggerShort,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),

              const SettingsAboutSectionWidget()
                  .animate()
                  .fadeIn(
                    delay: AnimationConstants.staggerMedium,
                    duration: AnimationConstants.medium,
                  )
                  .slideY(
                    begin: AnimationConstants.slideMedium,
                    end: 0,
                    delay: AnimationConstants.staggerMedium,
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.defaultCurve,
                  ),
            ],
          ),

          const FooterCardWidget()
              .animate()
              .fadeIn(
                delay: AnimationConstants.staggerLong,
                duration: AnimationConstants.medium,
              )
              .slideY(
                begin: AnimationConstants.slideLarge,
                end: 0,
                delay: AnimationConstants.staggerLong,
                duration: AnimationConstants.medium,
                curve: AnimationConstants.defaultCurve,
              ),
        ],
      ),
    );
  }
}
