import 'package:flutter/material.dart';

class Dimens {
  /// ---------------------------------------------------------------------------
  /// Base Size Constants
  /// These are the fundamental numeric values used throughout the Dimens class
  /// for spacing, padding, sizing, and layout.
  ///
  /// Naming Convention:
  /// - Numbers are written in words for readability.
  /// - These values are later scaled using `.i` (ScreenUtil responsive scaling).
  ///
  /// Example usage:
  /// EdgeInsets.all(sixteen.i)
  /// SizedBox(height: twentyFour.i)
  /// ---------------------------------------------------------------------------

  // Basic Sizes
  static double get zero => 0;

  static double get one => 1;

  static double get two => 2;

  static double get three => 3;

  static double get four => 4;

  static double get five => 5;

  static double get six => 6;

  static double get eight => 8;

  static double get ten => 10;

  static double get eleven => 11;

  static double get twelve => 12;

  static double get thirteen => 13;

  static double get fourteen => 14;

  static double get sixteen => 16;

  static double get eighteen => 18;

  static double get twenty => 20;

  static double get twentyTwo => 22;

  static double get twentyFour => 24;

  static double get twentySix => 26;

  static double get twentyEight => 28;

  static double get thirty => 30;

  static double get thirtyTwo => 32;

  static double get thirtySix => 36;

  static double get forty => 40;

  static double get fortyTwo => 42;

  static double get fortyFour => 44;

  static double get fortySix => 46;

  static double get fortyEight => 48;

  static double get fifty => 50;

  static double get fiftySix => 56;

  static double get sixty => 60;

  static double get sixtyFour => 64;

  static double get seventy => 70;

  static double get seventyTwo => 72;

  static double get seventyFive => 75;

  static double get eighty => 80;

  static double get eightySix => 86;

  static double get ninety => 90;

  static double get ninetySix => 96;

  static double get oneHundred => 100;

  static double get oneHundredTwelve => 112;

  static double get oneHundredTwenty => 120;

  static double get oneHundredTwentyEight => 128;

  static double get oneHundredThirty => 130;

  static double get oneHundredForty => 140;

  static double get oneHundredFifty => 150;

  static double get oneHundredSixty => 160;

  static double get oneHundredSeventy => 170;

  static double get oneHundredEighty => 180;

  static double get twoHundred => 200;

  static double get twoHundredTwenty => 220;

  static double get twoHundredForty => 240;

  static double get twoHundredFifty => 250;

  static double get twoHundredSixty => 260;

  static double get twoHundredSeventy => 270;

  static double get twoHundredEighty => 280;

  static double get threeHundred => 300;

  static double get threeHundredTwenty => 320;

  static double get threeHundredForty => 340;

  static double get threeHundredSixty => 360;

  static double get threeHundredSeventyFive => 375;

  static double get fourHundred => 400;
  static double get fourHundredSixty => 460;

  static double get fiveHundred => 500;

  static double get sixHundred => 600;

  static double get sevenHundred => 700;

  /// Used for full circular shapes or unlimited radius
  /// Example: BorderRadius.circular(Dimens.nineNineNine)
  static double get nineNineNine => 999;

  /// ---------------------------------------------------------------------------
  /// Padding Utilities
  /// All padding values are responsive using `.i` (ScreenUtil scaling).
  /// Naming pattern:
  /// edgeInsetsX_Y → horizontal X, vertical Y
  /// edgeInsetsL → left padding
  /// edgeInsetsR → right padding
  /// edgeInsetsT → top padding
  /// edgeInsetsB → bottom padding
  /// ---------------------------------------------------------------------------

  /// ---------------------------------------------------------------------------
  /// Full Padding Sizes (All sides)
  /// Example: edgeInsets16 → EdgeInsets.all(16)
  /// ---------------------------------------------------------------------------

  static EdgeInsets get defaultPadding => EdgeInsets.all(twentyFour);

  static EdgeInsets get edgeInsets0 => EdgeInsets.zero;

  static EdgeInsets get edgeInsets1 => EdgeInsets.all(one);

  static EdgeInsets get edgeInsets2 => EdgeInsets.all(two);

  static EdgeInsets get edgeInsets4 => EdgeInsets.all(four);

  static EdgeInsets get edgeInsets6 => EdgeInsets.all(six);

  static EdgeInsets get edgeInsets8 => EdgeInsets.all(eight);

  static EdgeInsets get edgeInsets10 => EdgeInsets.all(ten);

  static EdgeInsets get edgeInsets12 => EdgeInsets.all(twelve);

  static EdgeInsets get edgeInsets14 => EdgeInsets.all(fourteen);

  static EdgeInsets get edgeInsets16 => EdgeInsets.all(sixteen);

  static EdgeInsets get edgeInsets18 => EdgeInsets.all(eighteen);

  static EdgeInsets get edgeInsets20 => EdgeInsets.all(twenty);

  static EdgeInsets get edgeInsets24 => EdgeInsets.all(twentyFour);

  static EdgeInsets get edgeInsets28 => EdgeInsets.all(twentyEight);

  static EdgeInsets get edgeInsets32 => EdgeInsets.all(thirtyTwo);

  static EdgeInsets get edgeInsets40 => EdgeInsets.all(forty);

  static EdgeInsets get edgeInsets48 => EdgeInsets.all(fortyEight);

  static EdgeInsets get edgeInsets56 => EdgeInsets.all(fiftySix);


  static EdgeInsets get edgeInsets4_0 =>
      EdgeInsets.symmetric(horizontal: four);

  static EdgeInsets get edgeInsets6_0 =>
      EdgeInsets.symmetric(horizontal: six);

  static EdgeInsets get edgeInsets8_0 =>
      EdgeInsets.symmetric(horizontal: eight);

  static EdgeInsets get edgeInsets12_0 =>
      EdgeInsets.symmetric(horizontal: twelve);

  static EdgeInsets get edgeInsets14_0 =>
      EdgeInsets.symmetric(horizontal: fourteen);

  static EdgeInsets get edgeInsets16_0 =>
      EdgeInsets.symmetric(horizontal: sixteen);


  static EdgeInsets get edgeInsets20_0 =>
      EdgeInsets.symmetric(horizontal: twenty);

  static EdgeInsets get edgeInsets24_0 =>
      EdgeInsets.symmetric(horizontal: twentyFour);

  static EdgeInsets get edgeInsets30_0 =>
      EdgeInsets.symmetric(horizontal: thirty, vertical: zero);

  static EdgeInsets get edgeInsets32_0 =>
      EdgeInsets.symmetric(horizontal: thirtyTwo);

  /// ---------------------------------------------------------------------------
  /// Vertical Padding (Top + Bottom)
  /// Example: edgeInsets0_16 → EdgeInsets.symmetric(vertical: 16)
  /// ---------------------------------------------------------------------------

  static EdgeInsets get edgeInsets0_2 => EdgeInsets.symmetric(vertical: two);

  static EdgeInsets get edgeInsets0_4 => EdgeInsets.symmetric(vertical: four);

  static EdgeInsets get edgeInsets0_8 =>
      EdgeInsets.symmetric(vertical: eight);

  static EdgeInsets get edgeInsets0_12 =>
      EdgeInsets.symmetric(vertical: twelve);

  static EdgeInsets get edgeInsets0_16 =>
      EdgeInsets.symmetric(vertical: sixteen);

  static EdgeInsets get edgeInsets0_18 =>
      EdgeInsets.symmetric(vertical: eighteen);

  static EdgeInsets get edgeInsets0_20 =>
      EdgeInsets.symmetric(vertical: twenty);

  static EdgeInsets get edgeInsets0_24 =>
      EdgeInsets.symmetric(vertical: twentyFour);

  static EdgeInsets get edgeInsets0_32 =>
      EdgeInsets.symmetric(vertical: thirtyTwo);

  /// ---------------------------------------------------------------------------
  /// Symmetric EdgeInsets (horizontal, vertical)
  /// Format: edgeInsetsH_V → horizontal, vertical
  /// Example: edgeInsets16_8 = horizontal 16, vertical 8
  /// All values use `.w` for responsive scaling via ScreenUtil.
  /// ---------------------------------------------------------------------------
  static EdgeInsets get edgeInsets16_4 =>
      EdgeInsets.symmetric(horizontal: sixteen,vertical: four);
  static EdgeInsets get edgeInsets4_2 =>
      EdgeInsets.symmetric(horizontal: four, vertical: two);

  static EdgeInsets get edgeInsets4_8 =>
      EdgeInsets.symmetric(horizontal: four, vertical: eight);

  static EdgeInsets get edgeInsets4_10 =>
      EdgeInsets.symmetric(horizontal: four, vertical: ten);

  static EdgeInsets get edgeInsets4_12 =>
      EdgeInsets.symmetric(horizontal: four, vertical: twelve);

  static EdgeInsets get edgeInsets4_16 =>
      EdgeInsets.symmetric(horizontal: four, vertical: sixteen);

  static EdgeInsets get edgeInsets4_20 =>
      EdgeInsets.symmetric(horizontal: four, vertical: twenty);

  static EdgeInsets get edgeInsets4_24 =>
      EdgeInsets.symmetric(horizontal: four, vertical: twentyFour);

  static EdgeInsets get edgeInsets6_2 =>
      EdgeInsets.symmetric(horizontal: six, vertical: two);

  static EdgeInsets get edgeInsets6_4 =>
      EdgeInsets.symmetric(horizontal: six, vertical: four);

  static EdgeInsets get edgeInsets6_10 =>
      EdgeInsets.symmetric(horizontal: six, vertical: ten);

  static EdgeInsets get edgeInsets6_16 =>
      EdgeInsets.symmetric(horizontal: six, vertical: sixteen);

  static EdgeInsets get edgeInsets8_2 =>
      EdgeInsets.symmetric(horizontal: eight, vertical: two);

  static EdgeInsets get edgeInsets8_4 =>
      EdgeInsets.symmetric(horizontal: eight, vertical: four);

  static EdgeInsets get edgeInsets8_12 =>
      EdgeInsets.symmetric(horizontal: eight, vertical: twelve);

  static EdgeInsets get edgeInsets8_16 =>
      EdgeInsets.symmetric(horizontal: eight, vertical: sixteen);

  static EdgeInsets get edgeInsets8_20 =>
      EdgeInsets.symmetric(horizontal: eight, vertical: twenty);

  static EdgeInsets get edgeInsets8_24 =>
      EdgeInsets.symmetric(horizontal: eight, vertical: twentyFour);

  static EdgeInsets get edgeInsets10_4 =>
      EdgeInsets.symmetric(horizontal: ten, vertical: four);

  static EdgeInsets get edgeInsets10_6 =>
      EdgeInsets.symmetric(horizontal: ten, vertical: six);

  static EdgeInsets get edgeInsets12_4 =>
      EdgeInsets.symmetric(horizontal: twelve, vertical: four);

  static EdgeInsets get edgeInsets12_6 =>
      EdgeInsets.symmetric(horizontal: twelve, vertical: six);

  static EdgeInsets get edgeInsets12_8 =>
      EdgeInsets.symmetric(horizontal: twelve, vertical: eight);

  static EdgeInsets get edgeInsets12_10 =>
      EdgeInsets.symmetric(horizontal: twelve, vertical: ten);



  /// ---------------------------------------------------------------------------
  /// Border Radius Utilities
  /// Provides reusable radius values used across the application for
  /// rounded containers, cards, buttons, dialogs, and shapes.
  ///
  /// Usage Examples:
  /// Container(borderRadius: Dimens.radius12)
  /// ClipRRect(borderRadius: Dimens.radius16)
  ///
  /// These values use `.w` scaling for responsive layouts.
  /// ---------------------------------------------------------------------------

  /// Circular BorderRadius
  static BorderRadius get radius0 => BorderRadius.circular(zero);

  static BorderRadius get radius2 => BorderRadius.circular(two);

  static BorderRadius get radius4 => BorderRadius.circular(four);

  static BorderRadius get radius6 => BorderRadius.circular(six);

  static BorderRadius get radius8 => BorderRadius.circular(eight);

  static BorderRadius get radius10 => BorderRadius.circular(ten);

  static BorderRadius get radius12 => BorderRadius.circular(twelve);

  static BorderRadius get radius14 => BorderRadius.circular(fourteen);

  static BorderRadius get radius16 => BorderRadius.circular(sixteen);

  static BorderRadius get radius18 => BorderRadius.circular(eighteen);

  static BorderRadius get radius20 => BorderRadius.circular(twenty);

  static BorderRadius get radius22 => BorderRadius.circular(twentyTwo);

  static BorderRadius get radius24 => BorderRadius.circular(twentyFour);


  /// ---------------------------------------------------------------------------
  /// Single Corner Radius
  /// Used when applying radius to specific corners using `BorderRadius.only`.
  ///
  /// Example:
  /// BorderRadius.only(topLeft: Dimens.cornerRadius12)
  /// ---------------------------------------------------------------------------

  static Radius get cornerRadius0 => Radius.circular(zero);

  static Radius get cornerRadius4 => Radius.circular(four);

  static Radius get cornerRadius8 => Radius.circular(eight);

  static Radius get cornerRadius12 => Radius.circular(twelve);

  static Radius get cornerRadius16 => Radius.circular(sixteen);

  static Radius get cornerRadius18 => Radius.circular(eighteen);

  static Radius get cornerRadius20 => Radius.circular(twenty);

  static Radius get cornerRadius24 => Radius.circular(twentyFour);




  /// ---------------------------------------------------------------------------
  /// Default Spacing
  /// Common spacing values used between UI elements.
  /// ---------------------------------------------------------------------------

  static double get defaultSpace => twentyFour;

  static double get spaceBtwItems => sixteen;

  static double get spaceBtwSections => thirtyTwo;

  static double get spaceBtwInputFields => sixteen;


  /// ---------------------------------------------------------------------------
  /// Font Sizes (Responsive)
  /// Standard typography scale used across the application.
  /// Uses `.sp` for responsive text scaling.
  /// ---------------------------------------------------------------------------

  static double get font2Xs => 10;

  static double get fontXs => 12;

  static double get fontSm => 14;

  static double get fontMd => 16;

  static double get fontLg => 18;

  static double get fontXl => 20;

  static double get font2Xl => 24;

  static double get font3Xl => 28;

  static double get font4Xl => 32;

  static double get font5Xl => 36;

  static double get font6Xl => 40;

  static double get font7Xl => 48;

  static double get font8Xl => 56;

  static double get font9Xl => 64;

  /// ---------------------------------------------------------------------------
  /// Border Radius Sizes
  /// Used for small UI components like chips, buttons, cards.
  /// ---------------------------------------------------------------------------

  static double get borderRadiusSm => four;

  static double get borderRadiusMd => eight;

  static double get borderRadiusLg => twelve;

  /// Input field radius
  static double get inputFieldRadius => twelve;

  /// ---------------------------------------------------------------------------
  /// Icon Sizes
  /// Used for icons across the application.
  /// ---------------------------------------------------------------------------

  static double get iconXs => twelve;

  static double get iconSm => sixteen;

  static double get iconMd => twentyFour;

  static double get iconLg => thirtyTwo;

  static double get iconXl => forty;

  static double get icon2Xl => fortyEight;

  static double get icon3Xl => fiftySix;

  static double get icon4Xl => sixtyFour;

  static double get icon5Xl => eighty;

  static double get icon6Xl => ninetySix;

  static double get icon7Xl => oneHundredTwelve;

  static double get icon8Xl => oneHundredTwentyEight;



  static double get radiusSm => 8;
  static double get radiusMd => 12;
  static double get radiusLg => 16;
  static double get radiusXl => 20;

  /// Full circular radius
  // static double get cardRadiusFull => nineNineNine.i;

  /// ---------------------------------------------------------------------------
  /// Miscellaneous UI Sizes
  /// ---------------------------------------------------------------------------

  /// Divider thickness
  static double get dividerHeight => one;

  /// Standard elevated button height
  static double get elevatedButtonHeight => sixtyFour;
}
