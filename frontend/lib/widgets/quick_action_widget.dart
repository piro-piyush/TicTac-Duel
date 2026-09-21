import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class QuickActionWidget extends StatelessWidget {
  const QuickActionWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Themes.textSecondary,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: TextButton.styleFrom(foregroundColor: color),
    );
  }
}
