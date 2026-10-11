import 'package:tictac_duel/lib.dart';

class CreateRoomContentWidget extends StatelessWidget {
  const CreateRoomContentWidget({
    super.key,
    required this.formKey,
    required this.playerNameController,
    required this.playerNameFocusNode,
    required this.selectedSymbol,
    required this.selectedTheme,
    required this.selectedMaxRounds,
    required this.isRoomPrivate,
    required this.onSymbolChanged,
    required this.onThemeChanged,
    required this.onRoundsChanged,
    required this.onPrivateRoomChanged,
    required this.onGenerateRandomName,
    required this.onBrowsePublicRooms,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController playerNameController;
  final FocusNode playerNameFocusNode;

  final PlayerSymbol selectedSymbol;
  final RoomTheme selectedTheme;
  final int selectedMaxRounds;
  final bool isRoomPrivate;

  final ValueChanged<PlayerSymbol> onSymbolChanged;
  final ValueChanged<RoomTheme> onThemeChanged;
  final ValueChanged<int> onRoundsChanged;
  final ValueChanged<bool> onPrivateRoomChanged;

  final VoidCallback onGenerateRandomName;
  final VoidCallback onBrowsePublicRooms;

  @override
  Widget build(BuildContext context) => Column(
    spacing: Dimens.defaultSpace,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RoomHeaderWidget(
            eyebrow: 'READY FOR A',
            title: 'NEW DUEL?',
            description: 'Set up your room and challenge a rival.',
          )
          .animate()
          .fadeIn(duration: AnimationConstants.medium)
          .slideY(
            begin: -AnimationConstants.slideMedium,
            end: 0,
            duration: AnimationConstants.medium,
            curve: AnimationConstants.defaultCurve,
          ),

      PlayerNameWidget(
            playerNameController: playerNameController,
            playerNameFocusNode: playerNameFocusNode,
            onPressed: onGenerateRandomName,
            formKey: formKey,
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

      ChooseYourSymbolWidget(
            selectedSymbol: selectedSymbol,
            onSymbolChanged: onSymbolChanged,
          )
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

      RoundSelectorWidget(
            selectedRounds: selectedMaxRounds,
            onRoundChanged: onRoundsChanged,
          )
          .animate()
          .fadeIn(
            delay: AnimationConstants.staggerLong,
            duration: AnimationConstants.medium,
          )
          .slideY(
            begin: AnimationConstants.slideMedium,
            end: 0,
            delay: AnimationConstants.staggerLong,
            duration: AnimationConstants.medium,
            curve: AnimationConstants.defaultCurve,
          ),

      SelectRoomThemeWidget(
            selectedTheme: selectedTheme,
            onThemeChanged: onThemeChanged,
          )
          .animate()
          .fadeIn(
            delay: AnimationConstants.extraLong,
            duration: AnimationConstants.medium,
          )
          .slideY(
            begin: AnimationConstants.slideMedium,
            end: 0,
            delay: AnimationConstants.extraLong,
            duration: AnimationConstants.medium,
            curve: AnimationConstants.defaultCurve,
          ),

      SectionTileWidget.withSwitch(
            icon: Icons.lock_rounded,
            title: 'Private Room',
            subtitle: isRoomPrivate
                ? 'Only players with the room code can join.'
                : 'Anyone can discover and join this room.',
            color: AppColors.neonPink,
            value: isRoomPrivate,
            onChanged: onPrivateRoomChanged,
          )
          .animate()
          .fadeIn(
            delay: AnimationConstants.extraLong,
            duration: AnimationConstants.medium,
          )
          .slideY(
            begin: AnimationConstants.slideMedium,
            end: 0,
            delay: AnimationConstants.extraLong,
            duration: AnimationConstants.medium,
            curve: AnimationConstants.defaultCurve,
          ),

      const CreateRoomInfoWidget().animate().fadeIn(
        delay: AnimationConstants.extraLong,
        duration: AnimationConstants.medium,
      ),

      const OrDividerWidget().animate().fadeIn(
        delay: AnimationConstants.extraLong,
        duration: AnimationConstants.medium,
      ),

      NeonOutlinedButtonWidget.icon(
            label: 'BROWSE PUBLIC ROOMS',
            icon: Icons.public_rounded,
            onPressed: onBrowsePublicRooms,
          )
          .animate()
          .fadeIn(
            delay: AnimationConstants.extraLong,
            duration: AnimationConstants.medium,
          )
          .slideY(
            begin: AnimationConstants.slideLarge,
            end: 0,
            delay: AnimationConstants.extraLong,
            duration: AnimationConstants.medium,
            curve: AnimationConstants.defaultCurve,
          ),
    ],
  );
}
