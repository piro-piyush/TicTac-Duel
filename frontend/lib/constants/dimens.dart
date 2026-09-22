import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  Dimens._();

  // ============================================================
  // Base Numbers
  // ============================================================

  static const double _space4 = 4;
  static const double _space8 = 8;
  static const double _space12 = 12;
  static const double _space16 = 16;
  static const double _space20 = 20;
  static const double _space24 = 24;
  static const double _space28 = 28;
  static const double _space32 = 32;
  static const double _space40 = 40;

  static const double _radius8 = 8;
  static const double _radius12 = 12;
  static const double _radius14 = 14;
  static const double _radius16 = 16;
  static const double _radius20 = 20;

  static const double _icon16 = 16;
  static const double _icon20 = 20;
  static const double _icon24 = 24;
  static const double _icon32 = 32;

  static const double _text10 = 10;
  static const double _text12 = 12;
  static const double _text14 = 14;
  static const double _text16 = 16;
  static const double _text18 = 18;
  static const double _text20 = 20;
  static const double _text24 = 24;
  static const double _text28 = 28;
  static const double _text32 = 32;

  // ============================================================
  // Spacing
  // ============================================================

  static final double space4 = _space4.w;
  static final double space8 = _space8.w;
  static final double space12 = _space12.w;
  static final double space16 = _space16.w;
  static final double space20 = _space20.w;
  static final double space24 = _space24.w;
  static final double space28 = _space28.w;
  static final double space32 = _space32.w;
  static final double space40 = _space40.w;

  // ============================================================
  // Padding
  // ============================================================

  static final EdgeInsets defaultPadding = EdgeInsets.fromLTRB(
    space20,
    space16,
    space20,
    space32,
  );
  static final EdgeInsets padding8 = EdgeInsets.all(space8);
  static final EdgeInsets padding12 = EdgeInsets.all(space12);
  static final EdgeInsets padding16 = EdgeInsets.all(space16);
  static final EdgeInsets padding20 = EdgeInsets.all(space20);
  static final EdgeInsets padding24 = EdgeInsets.all(space24);

  static final EdgeInsets horizontal16 = EdgeInsets.symmetric(
    horizontal: space16,
  );

  static final EdgeInsets horizontal20 = EdgeInsets.symmetric(
    horizontal: space20,
  );

  static final EdgeInsets horizontal24 = EdgeInsets.symmetric(
    horizontal: space24,
  );

  static final EdgeInsets vertical8 = EdgeInsets.symmetric(vertical: space8);

  static final EdgeInsets vertical12 = EdgeInsets.symmetric(vertical: space12);

  static final EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: space16);

  // ============================================================
  // Border Radius
  // ============================================================

  static final double radius8 = _radius8.r;
  static final double radius12 = _radius12.r;
  static final double radius14 = _radius14.r;
  static final double radius16 = _radius16.r;
  static final double radius20 = _radius20.r;

  static final BorderRadius radius8All = BorderRadius.circular(radius8);
  static final BorderRadius radius12All = BorderRadius.circular(radius12);
  static final BorderRadius radius14All = BorderRadius.circular(radius14);
  static final BorderRadius radius16All = BorderRadius.circular(radius16);
  static final BorderRadius radius20All = BorderRadius.circular(radius20);

  // ============================================================
  // Icon Sizes
  // ============================================================

  static final double icon16 = _icon16.r;
  static final double icon20 = _icon20.r;
  static final double icon24 = _icon24.r;
  static final double icon32 = _icon32.r;

  // ============================================================
  // Text Sizes
  // ============================================================

  static final double text10 = _text10.sp;
  static final double text12 = _text12.sp;
  static final double text14 = _text14.sp;
  static final double text16 = _text16.sp;
  static final double text18 = _text18.sp;
  static final double text20 = _text20.sp;
  static final double text24 = _text24.sp;
  static final double text28 = _text28.sp;
  static final double text32 = _text32.sp;

  // ============================================================
  // Common Components
  // ============================================================

  static final double buttonHeight = 48.h;
  static final double inputHeight = 48.h;
  static final double appBarHeight = 56.h;

  static final double screenPadding = space20;
  static final double cardPadding = space16;

  static final BorderRadius cardRadius = radius14All;
  static final BorderRadius buttonRadius = radius12All;
  static final BorderRadius inputRadius = radius12All;
}
