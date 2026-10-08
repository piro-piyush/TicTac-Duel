import 'package:tictac_duel/lib.dart';

class GameReactionBottomSheetWidget extends StatelessWidget {
  const GameReactionBottomSheetWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Dimens.spaceBtwSections,
          Dimens.spaceBtwItems,
          Dimens.spaceBtwSections,
          Dimens.spaceBtwSections,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Dimens.cornerRadius16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: Dimens.twenty,
              offset: const Offset(0, -Dimens.eight),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(theme),
            const SizedBox(height: Dimens.spaceBtwItems),
            _buildTitle(theme),
            const SizedBox(height: Dimens.spaceBtwItems),
            _buildReactionGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Container(
      width: Dimens.forty,
      height: Dimens.four,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
        borderRadius: Dimens.radius10,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'SEND A REACTION',
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildReactionGrid(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Dimens.spaceBtwItems,
      runSpacing: Dimens.spaceBtwItems,
      children: [
        for (final reaction in GameReaction.values)
          _buildReactionButton(context, reaction),
      ],
    );
  }

  Widget _buildReactionButton(BuildContext context, GameReaction reaction) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.pop(reaction);
        },
        borderRadius: Dimens.radius10,
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        child: Ink(
          width: Dimens.fifty,
          height: Dimens.fifty,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.45,
            ),
            borderRadius: Dimens.radius10,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Center(
            child: Lottie.network(
              reaction.animation,
              width: Dimens.forty,
              height: Dimens.forty,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
              frameRate: FrameRate.max,
            ),
          ),
        ),
      ),
    );
  }
}
