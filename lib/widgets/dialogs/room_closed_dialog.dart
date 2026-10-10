import 'package:tictac_duel/lib.dart';

class RoomClosedDialog extends StatelessWidget {
  const RoomClosedDialog({
    required this.reason,
    required this.onBack,
    required this.onHome,
    super.key,
  });

  final GameDismissReason reason;
  final VoidCallback onBack;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Column(
      spacing: Dimens.sixteen,
      children: [
        Container(
          width: Dimens.fiftySix,
          height: Dimens.fiftySix,
          decoration: BoxDecoration(
            color: reason.color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: reason.color.withValues(alpha: 0.35)),
          ),
          child: Icon(
            reason.icon,
            color: reason.color,
            size: Dimens.twentyEight,
          ),
        ),
        const Text('Room Closed', textAlign: TextAlign.center),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Dimens.twelve,
      children: [
        Text(
          reason.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Text(reason.subtitle, textAlign: TextAlign.center),
        const SizedBox(height: Dimens.four),
        Row(
          spacing: Dimens.twelve,
          children: [
            Expanded(
              child: NeonOutlinedButtonWidget(
                onPressed: () {
                  context.pop();
                  onBack();
                },
                label: 'BACK',
              ),
            ),
            Expanded(
              child: NeonElevatedButtonWidget(
                onPressed: () {
                  context.pop();
                  onHome();
                },
                label: 'HOME',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
