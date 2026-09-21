import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.secondaryColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color? secondaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradientEnd = secondaryColor ?? Themes.neonPurple;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Themes.surface,
                color.withValues(alpha: 0.08),
                gradientEnd.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: color.withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle neon glow in the top-right.
              Positioned(
                top: -45,
                right: -35,
                child: IgnorePointer(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.06),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.10),
                          blurRadius: 50,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    _IconContainer(
                      icon: icon,
                      color: color,
                      secondaryColor: gradientEnd,
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Themes.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Themes.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    _ArrowButton(
                      color: color,
                    ),
                  ],
                ),
              ),

              // Bottom neon accent.
              Positioned(
                left: 20,
                bottom: 0,
                child: Container(
                  width: 42,
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        color,
                        gradientEnd,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.7),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.color,
    required this.secondaryColor,
  });

  final IconData icon;
  final Color color;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.22),
            secondaryColor.withValues(alpha: 0.10),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.16),
            blurRadius: 18,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.08),
        border: Border.all(
          color: color.withValues(alpha: 0.20),
        ),
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: color,
        size: 19,
      ),
    );
  }
}