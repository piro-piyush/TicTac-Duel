
import 'package:flutter/animation.dart';

abstract final class AnimationConstants {
  // ===========================================================================
  // ANIMATION ASSETS
  // ===========================================================================

  static const String trophyAnimation =
      'assets/animations/trophy.json';

  static const String loseAnimation =
      'assets/animations/lose.json';

  // ===========================================================================
  // DURATIONS
  // ===========================================================================

  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration short = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 700);
  static const Duration extraLong = Duration(milliseconds: 1000);

  // ===========================================================================
  // STAGGER DELAYS
  // ===========================================================================

  static const Duration noDelay = Duration.zero;
  // Stagger delays
  static const Duration staggerShort = Duration(milliseconds: 150);
  static const Duration staggerMedium = Duration(milliseconds: 300);
  static const Duration staggerLong = Duration(milliseconds: 450);


  // ===========================================================================
  // SLIDE DISTANCES
  // ===========================================================================

  static const double slideSmall = 0.08;
  static const double slideMedium = 0.12;
  static const double slideLarge = 0.18;

  // ===========================================================================
  // SCALE
  // ===========================================================================

  static const double scaleSmall = 0.90;
  static const double scaleMedium = 0.82;
  static const double scaleNormal = 1.0;
  static const Offset scaleBegin = Offset(0.90, 0.90);
  static const Offset scaleEnd = Offset(1.0, 1.0);
  // ===========================================================================
  // CURVES
  // ===========================================================================

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve entranceCurve = Curves.easeOutBack;
  static const Curve exitCurve = Curves.easeInCubic;

  // Home screen delays
  static const Duration homeTitleDelay = Duration(milliseconds: 180);
  static const Duration homeSloganDelay = Duration(milliseconds: 320);

  static const double logoEntranceRotation = -0.04;
  static const double logoRestingRotation = 0.0;
}
