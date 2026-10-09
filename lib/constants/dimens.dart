import 'package:flutter/material.dart';

abstract final class Dimens {
  Dimens._();

  // ---------------------------------------------------------------------------
  // Base Size Constants
  // ---------------------------------------------------------------------------

  static const double zero = 0;
  static const double one = 1;
  static const double two = 2;
  static const double three = 3;
  static const double four = 4;
  static const double five = 5;
  static const double six = 6;
  static const double eight = 8;
  static const double ten = 10;
  static const double eleven = 11;
  static const double twelve = 12;
  static const double thirteen = 13;
  static const double fourteen = 14;
  static const double sixteen = 16;
  static const double eighteen = 18;
  static const double twenty = 20;
  static const double twentyTwo = 22;
  static const double twentyFour = 24;
  static const double twentySix = 26;
  static const double twentyEight = 28;
  static const double thirty = 30;
  static const double thirtyTwo = 32;
  static const double thirtySix = 36;
  static const double forty = 40;
  static const double fortyTwo = 42;
  static const double fortyFour = 44;
  static const double fortySix = 46;
  static const double fortyEight = 48;
  static const double fifty = 50;
  static const double fiftySix = 56;
  static const double sixty = 60;
  static const double sixtyFour = 64;
  static const double seventy = 70;
  static const double seventyTwo = 72;
  static const double seventyFive = 75;
  static const double eighty = 80;
  static const double eightyEight = 88;
  static const double eightySix = 86;
  static const double ninety = 90;
  static const double ninetySix = 96;
  static const double oneHundred = 100;
  static const double oneHundredTwelve = 112;
  static const double oneHundredTwenty = 120;
  static const double oneHundredTwentyEight = 128;
  static const double oneHundredThirty = 130;
  static const double oneHundredForty = 140;
  static const double oneHundredFifty = 150;
  static const double oneHundredSixty = 160;
  static const double oneHundredSeventy = 170;
  static const double oneHundredEighty = 180;
  static const double twoHundred = 200;
  static const double twoHundredTwenty = 220;
  static const double twoHundredForty = 240;
  static const double twoHundredFifty = 250;
  static const double twoHundredSixty = 260;
  static const double twoHundredSeventy = 270;
  static const double twoHundredEighty = 280;
  static const double threeHundred = 300;
  static const double threeHundredTwenty = 320;
  static const double threeHundredForty = 340;
  static const double threeHundredSixty = 360;
  static const double threeHundredSeventyFive = 375;
  static const double threeHundredEighty = 380;
  static const double fourHundred = 400;
  static const double fourHundredSixty = 460;
  static const double fiveHundred = 500;
  static const double sixHundred = 600;
  static const double sevenHundred = 700;

  static const double nineNineNine = 999;

  // ---------------------------------------------------------------------------
  // Padding
  // ---------------------------------------------------------------------------

  static const EdgeInsets defaultPadding = EdgeInsets.all(twentyFour);

  static const EdgeInsets edgeInsets0 = EdgeInsets.zero;
  static const EdgeInsets edgeInsets1 = EdgeInsets.all(one);
  static const EdgeInsets edgeInsets2 = EdgeInsets.all(two);
  static const EdgeInsets edgeInsets4 = EdgeInsets.all(four);
  static const EdgeInsets edgeInsets6 = EdgeInsets.all(six);
  static const EdgeInsets edgeInsets8 = EdgeInsets.all(eight);
  static const EdgeInsets edgeInsets10 = EdgeInsets.all(ten);
  static const EdgeInsets edgeInsets12 = EdgeInsets.all(twelve);
  static const EdgeInsets edgeInsets14 = EdgeInsets.all(fourteen);
  static const EdgeInsets edgeInsets16 = EdgeInsets.all(sixteen);
  static const EdgeInsets edgeInsets18 = EdgeInsets.all(eighteen);
  static const EdgeInsets edgeInsets20 = EdgeInsets.all(twenty);
  static const EdgeInsets edgeInsets24 = EdgeInsets.all(twentyFour);
  static const EdgeInsets edgeInsets28 = EdgeInsets.all(twentyEight);
  static const EdgeInsets edgeInsets32 = EdgeInsets.all(thirtyTwo);
  static const EdgeInsets edgeInsets40 = EdgeInsets.all(forty);
  static const EdgeInsets edgeInsets48 = EdgeInsets.all(fortyEight);
  static const EdgeInsets edgeInsets56 = EdgeInsets.all(fiftySix);

  static const EdgeInsets edgeInsets4_0 = EdgeInsets.symmetric(
    horizontal: four,
  );

  static const EdgeInsets edgeInsets6_0 = EdgeInsets.symmetric(horizontal: six);

  static const EdgeInsets edgeInsets8_0 = EdgeInsets.symmetric(
    horizontal: eight,
  );

  static const EdgeInsets edgeInsets12_0 = EdgeInsets.symmetric(
    horizontal: twelve,
  );

  static const EdgeInsets edgeInsets14_0 = EdgeInsets.symmetric(
    horizontal: fourteen,
  );

  static const EdgeInsets edgeInsets16_0 = EdgeInsets.symmetric(
    horizontal: sixteen,
  );

  static const EdgeInsets edgeInsets20_0 = EdgeInsets.symmetric(
    horizontal: twenty,
  );

  static const EdgeInsets edgeInsets24_0 = EdgeInsets.symmetric(
    horizontal: twentyFour,
  );
  static const EdgeInsets edgeInsets24_12 = EdgeInsets.symmetric(
    horizontal: twentyFour,
    vertical: 12
  );
  static const EdgeInsets edgeInsets30_0 = EdgeInsets.symmetric(
    horizontal: thirty,
  );

  static const EdgeInsets edgeInsets32_0 = EdgeInsets.symmetric(
    horizontal: thirtyTwo,
  );

  // ---------------------------------------------------------------------------
  // Vertical Padding
  // ---------------------------------------------------------------------------

  static const EdgeInsets edgeInsets0_2 = EdgeInsets.symmetric(vertical: two);

  static const EdgeInsets edgeInsets0_4 = EdgeInsets.symmetric(vertical: four);

  static const EdgeInsets edgeInsets0_8 = EdgeInsets.symmetric(vertical: eight);

  static const EdgeInsets edgeInsets0_12 = EdgeInsets.symmetric(
    vertical: twelve,
  );

  static const EdgeInsets edgeInsets0_16 = EdgeInsets.symmetric(
    vertical: sixteen,
  );

  static const EdgeInsets edgeInsets0_18 = EdgeInsets.symmetric(
    vertical: eighteen,
  );

  static const EdgeInsets edgeInsets0_20 = EdgeInsets.symmetric(
    vertical: twenty,
  );

  static const EdgeInsets edgeInsets0_24 = EdgeInsets.symmetric(
    vertical: twentyFour,
  );

  static const EdgeInsets edgeInsets0_32 = EdgeInsets.symmetric(
    vertical: thirtyTwo,
  );

  // ---------------------------------------------------------------------------
  // Symmetric Padding
  // ---------------------------------------------------------------------------

  static const EdgeInsets edgeInsets16_4 = EdgeInsets.symmetric(
    horizontal: sixteen,
    vertical: four,
  );

  static const EdgeInsets edgeInsets4_2 = EdgeInsets.symmetric(
    horizontal: four,
    vertical: two,
  );

  static const EdgeInsets edgeInsets4_8 = EdgeInsets.symmetric(
    horizontal: four,
    vertical: eight,
  );

  static const EdgeInsets edgeInsets20_24 = EdgeInsets.symmetric(
    horizontal: twenty,
    vertical: twentyFour,
  );

  static const EdgeInsets edgeInsets4_10 = EdgeInsets.symmetric(
    horizontal: four,
    vertical: ten,
  );

  static const EdgeInsets edgeInsets4_12 = EdgeInsets.symmetric(
    horizontal: four,
    vertical: twelve,
  );

  static const EdgeInsets edgeInsets4_16 = EdgeInsets.symmetric(
    horizontal: four,
    vertical: sixteen,
  );

  static const EdgeInsets edgeInsets4_20 = EdgeInsets.symmetric(
    horizontal: four,
    vertical: twenty,
  );

  static const EdgeInsets edgeInsets4_24 = EdgeInsets.symmetric(
    horizontal: four,
    vertical: twentyFour,
  );

  static const EdgeInsets edgeInsets6_2 = EdgeInsets.symmetric(
    horizontal: six,
    vertical: two,
  );

  static const EdgeInsets edgeInsets6_4 = EdgeInsets.symmetric(
    horizontal: six,
    vertical: four,
  );

  static const EdgeInsets edgeInsets6_10 = EdgeInsets.symmetric(
    horizontal: six,
    vertical: ten,
  );

  static const EdgeInsets edgeInsets6_16 = EdgeInsets.symmetric(
    horizontal: six,
    vertical: sixteen,
  );

  static const EdgeInsets edgeInsets8_2 = EdgeInsets.symmetric(
    horizontal: eight,
    vertical: two,
  );

  static const EdgeInsets edgeInsets8_4 = EdgeInsets.symmetric(
    horizontal: eight,
    vertical: four,
  );

  static const EdgeInsets edgeInsets8_12 = EdgeInsets.symmetric(
    horizontal: eight,
    vertical: twelve,
  );

  static const EdgeInsets edgeInsets8_16 = EdgeInsets.symmetric(
    horizontal: eight,
    vertical: sixteen,
  );

  static const EdgeInsets edgeInsets8_20 = EdgeInsets.symmetric(
    horizontal: eight,
    vertical: twenty,
  );

  static const EdgeInsets edgeInsets8_24 = EdgeInsets.symmetric(
    horizontal: eight,
    vertical: twentyFour,
  );

  static const EdgeInsets edgeInsets10_4 = EdgeInsets.symmetric(
    horizontal: ten,
    vertical: four,
  );

  static const EdgeInsets edgeInsets10_6 = EdgeInsets.symmetric(
    horizontal: ten,
    vertical: six,
  );

  static const EdgeInsets edgeInsets12_4 = EdgeInsets.symmetric(
    horizontal: twelve,
    vertical: four,
  );

  static const EdgeInsets edgeInsets12_6 = EdgeInsets.symmetric(
    horizontal: twelve,
    vertical: six,
  );

  static const EdgeInsets edgeInsets12_8 = EdgeInsets.symmetric(
    horizontal: twelve,
    vertical: eight,
  );

  static const EdgeInsets edgeInsets12_10 = EdgeInsets.symmetric(
    horizontal: twelve,
    vertical: ten,
  );

  static const EdgeInsets edgeInsets12_16 = EdgeInsets.symmetric(
    horizontal: twelve,
    vertical: sixteen,
  );

  // ---------------------------------------------------------------------------
  // Bottom Padding
  // ---------------------------------------------------------------------------

  static const EdgeInsets edgeInsetsB2 = EdgeInsets.only(bottom: two);

  static const EdgeInsets edgeInsetsB4 = EdgeInsets.only(bottom: four);

  static const EdgeInsets edgeInsetsB6 = EdgeInsets.only(bottom: six);

  static const EdgeInsets edgeInsetsB8 = EdgeInsets.only(bottom: eight);

  static const EdgeInsets edgeInsetsB10 = EdgeInsets.only(bottom: ten);

  static const EdgeInsets edgeInsetsB12 = EdgeInsets.only(bottom: twelve);

  // ---------------------------------------------------------------------------
  // Border Radius
  // ---------------------------------------------------------------------------

  static const BorderRadius radius0 = BorderRadius.all(Radius.circular(zero));

  static const BorderRadius radius2 = BorderRadius.all(Radius.circular(two));

  static const BorderRadius radius4 = BorderRadius.all(Radius.circular(four));

  static const BorderRadius radius6 = BorderRadius.all(Radius.circular(six));

  static const BorderRadius radius8 = BorderRadius.all(Radius.circular(eight));

  static const BorderRadius radius10 = BorderRadius.all(Radius.circular(ten));

  static const BorderRadius radius12 = BorderRadius.all(
    Radius.circular(twelve),
  );

  static const BorderRadius radius14 = BorderRadius.all(
    Radius.circular(fourteen),
  );

  static const BorderRadius radius16 = BorderRadius.all(
    Radius.circular(sixteen),
  );

  static const BorderRadius radius18 = BorderRadius.all(
    Radius.circular(eighteen),
  );

  static const BorderRadius radius20 = BorderRadius.all(
    Radius.circular(twenty),
  );

  static const BorderRadius radius22 = BorderRadius.all(
    Radius.circular(twentyTwo),
  );

  static const BorderRadius radius24 = BorderRadius.all(
    Radius.circular(twentyFour),
  );

  static const BorderRadius radius30 = BorderRadius.all(
    Radius.circular(thirty),
  );

  // ---------------------------------------------------------------------------
  // Corner Radius
  // ---------------------------------------------------------------------------

  static const Radius cornerRadius0 = Radius.circular(zero);
  static const Radius cornerRadius4 = Radius.circular(four);
  static const Radius cornerRadius8 = Radius.circular(eight);
  static const Radius cornerRadius12 = Radius.circular(twelve);
  static const Radius cornerRadius16 = Radius.circular(sixteen);
  static const Radius cornerRadius18 = Radius.circular(eighteen);
  static const Radius cornerRadius20 = Radius.circular(twenty);
  static const Radius cornerRadius24 = Radius.circular(twentyFour);

  // ---------------------------------------------------------------------------
  // Default Spacing
  // ---------------------------------------------------------------------------

  static const double defaultSpace = twentyFour;
  static const double spaceBtwItems = sixteen;
  static const double spaceBtwSections = thirtyTwo;
  static const double spaceBtwInputFields = sixteen;

  // ---------------------------------------------------------------------------
  // Font Sizes
  // ---------------------------------------------------------------------------

  static const double font2Xs = 10;
  static const double fontXs = 12;
  static const double fontSm = 14;
  static const double fontMd = 16;
  static const double fontLg = 18;
  static const double fontXl = 20;
  static const double font2Xl = 24;
  static const double font3Xl = 28;
  static const double font4Xl = 32;
  static const double font5Xl = 36;
  static const double font6Xl = 40;
  static const double font7Xl = 48;
  static const double font8Xl = 56;
  static const double font9Xl = 64;

  // ---------------------------------------------------------------------------
  // Component Border Radius
  // ---------------------------------------------------------------------------

  static const double borderRadiusSm = four;
  static const double borderRadiusMd = eight;
  static const double borderRadiusLg = twelve;
  static const double inputFieldRadius = twelve;

  // ---------------------------------------------------------------------------
  // Icon Sizes
  // ---------------------------------------------------------------------------

  static const double iconXs = twelve;
  static const double iconSm = sixteen;
  static const double iconMd = twentyFour;
  static const double iconLg = thirtyTwo;
  static const double iconXl = forty;
  static const double icon2Xl = fortyEight;
  static const double icon3Xl = fiftySix;
  static const double icon4Xl = sixtyFour;
  static const double icon5Xl = eighty;
  static const double icon6Xl = ninetySix;
  static const double icon7Xl = oneHundredTwelve;
  static const double icon8Xl = oneHundredTwentyEight;

  // ---------------------------------------------------------------------------
  // Legacy / General Radius
  // ---------------------------------------------------------------------------

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;

  // ---------------------------------------------------------------------------
  // Miscellaneous
  // ---------------------------------------------------------------------------

  static const double dividerHeight = one;
  static const double elevatedButtonHeight = sixtyFour;

  // =============================================================================
// RESPONSIVE LAYOUT
// =============================================================================

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static const double mobileMaxContentWidth = 460;
  static const double tabletMaxContentWidth = 500;
  static const double desktopMaxContentWidth = 640;
}
