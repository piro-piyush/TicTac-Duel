import 'package:tictac_duel/lib.dart';

class VersusWidget extends StatelessWidget {
  final bool compact;

  const VersusWidget({super.key, required this.compact});

  @override
  Widget build(BuildContext context) {
    final size = compact ? 24.0 : 28.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Themes.card,
        shape: BoxShape.circle,
        border: Border.all(color: Themes.border),
      ),
      child: Center(
        child: Text(
          'VS',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: compact ? 7 : 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
