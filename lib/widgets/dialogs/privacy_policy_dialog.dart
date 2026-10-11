import 'package:tictac_duel/lib.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Privacy Policy'),
    content: const SingleChildScrollView(
      child: Text(GameConstants.privacyPolicyText),
    ),
    actions: [
      NeonTextButtonWidget(
        onPressed: context.pop,
        label: 'CLOSE',
        isSmall: true,
      ),
    ],
  );
}
