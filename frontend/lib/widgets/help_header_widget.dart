import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class HelpHeaderWidget extends StatelessWidget {
  const HelpHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Themes.neonCyan.withValues(alpha: 0.10),
            Themes.neonPurple.withValues(alpha: 0.08),
            Themes.surface,
          ],
        ),
        border: Border.all(color: Themes.neonCyan.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Themes.neonCyan.withValues(alpha: 0.06),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  Themes.neonCyan.withValues(alpha: 0.20),
                  Themes.neonPurple.withValues(alpha: 0.15),
                ],
              ),
              border: Border.all(
                color: Themes.neonCyan.withValues(alpha: 0.30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Themes.neonCyan.withValues(alpha: 0.15),
                  blurRadius: 18,
                ),
              ],
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: Themes.neonCyan,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEED A HAND?',
                  style: TextStyle(
                    color: Themes.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Everything you need to dominate the board.',
                  style: TextStyle(
                    color: Themes.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
