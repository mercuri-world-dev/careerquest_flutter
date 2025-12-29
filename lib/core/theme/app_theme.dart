import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const String displayFont = 'FuturaPT';
  static const String uiFont = 'AlteHaasGrotesk';

  // Primary colors
  static const Color darkBlue = Color(0xFF20316D);
  static const Color deepPurple = Color(0xFF442079);
  static const Color violet = Color(0xFF9E88E8);
  static const Color brightViolet = Color(0xFFD87CFF); // idek with these names
  static const Color darkViolet = Color(0xFF7113C9);
  static const Color cyanAccent = Color(0xFF88F9FF);

  static const Color teal = Color(0xFF70D0B9);
  static const Color lightTeal = Color(0xFF9CC8D6);
  // result of 80% lerp from brightViolet to lightTeal; used in job search
  static const Color tealyViolet = Color(0xFFa8b9de);

  // Card / panel
  static const Color cardGradientStart = Color(0xFFFFFFFF);
  static const Color cardGradientEnd = Color(0xFFF0DFF7);

  // Background/neutral
  static const Color paleViolet = Color(0xFFF2E9FB);
  static const Color pageBackground = Color(0xFFE9F7F6);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color muted = Color(0xFF6B7280);

  // Text styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: const ['NotoSans'],

    color: Colors.white,
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.0,
  );

  static const TextStyle label = TextStyle(
    fontFamily: uiFont,
    fontFamilyFallback: const ['NotoSans'],

    color: Color(0xFF20316D),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const double inputRadius = 13.0;

  // Utility sizes
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
}

class CQColors {
  CQColors._();

  static const Color darkBlue = AppTheme.darkBlue;
  static const Color deepPurple = AppTheme.deepPurple;
  static const Color violet = AppTheme.violet;
  static const Color brightViolet = AppTheme.brightViolet;
  static const Color darkViolet = AppTheme.darkViolet;
  static const Color cyanAccent = AppTheme.cyanAccent;

  static const Color teal = AppTheme.teal;
  static const Color lightTeal = AppTheme.lightTeal;
  static const Color tealyViolet = AppTheme.tealyViolet;

  static const Color cardGradientStart = AppTheme.cardGradientStart;
  static const Color cardGradientEnd = AppTheme.cardGradientEnd;

  static const Color pageBackground = AppTheme.pageBackground;
  static const Color paleViolet = AppTheme.paleViolet;

  static const Color white = AppTheme.white;
  static const Color black = AppTheme.black;
  static const Color muted = AppTheme.muted;

  static const Color link = cyanAccent;
}

class CQGradients {
  CQGradients._();

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [CQColors.darkBlue, CQColors.deepPurple],
  );

  static const LinearGradient card = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [CQColors.cardGradientStart, CQColors.cardGradientEnd],
  );
}

class CQTypography {
  CQTypography._();

  static const String displayFont = 'FuturaPT';
  static const String uiFont = 'AlteHaasGrotesk';

  static const TextStyle display = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: const ['NotoSans'],
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: CQColors.white,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: uiFont,
    fontFamilyFallback: const ['NotoSans'],
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: CQColors.darkBlue,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: uiFont,
    fontFamilyFallback: const ['NotoSans'],
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: CQColors.darkBlue,
  );

  static const TextStyle body = TextStyle(
    fontFamily: uiFont,
    fontFamilyFallback: const ['NotoSans'],
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CQColors.darkBlue,
  );

  static const TextStyle label = TextStyle(
    fontFamily: uiFont,
    fontFamilyFallback: const ['NotoSans'],
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CQColors.darkBlue,
  );

  static const TextStyle button = TextStyle(
    fontFamily: uiFont,
    fontFamilyFallback: const ['NotoSans'],
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: CQColors.white,
  );
}

class CQSpacing {
  CQSpacing._();
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

class CQRadii {
  CQRadii._();
  static const double small = 6.0;
  static const double medium = 12.0;
  static const double card = 20.0;
  static const double pill = 46.0;
}

class CQShadows {
  CQShadows._();
  static const List<BoxShadow> low = [
    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
  ];
}

class CQBreakpoints {
  CQBreakpoints._();
  static const double small = 600;
  static const double medium = 1024;
}

class CQSizes {
  CQSizes._();
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
}
