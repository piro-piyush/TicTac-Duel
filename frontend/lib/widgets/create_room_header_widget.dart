import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class CreateRoomHeaderWidget extends StatelessWidget {
  const CreateRoomHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'READY FOR A',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: 13,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'NEW DUEL?',
          style: TextStyle(
            color: Themes.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Set up your arena and challenge a rival.',
          style: TextStyle(
            color: Themes.textSecondary.withValues(alpha: 0.9),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
