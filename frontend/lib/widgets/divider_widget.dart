import 'package:tictac_duel/lib.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 50,
      endIndent: 14,
      color: AppColors.border.withValues(alpha: 0.7),
    );
  }
}
