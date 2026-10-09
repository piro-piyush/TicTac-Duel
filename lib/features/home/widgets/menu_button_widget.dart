import 'package:tictac_duel/lib.dart';

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionTileWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: color,
      onTap: onTap,
    );
  }
}
