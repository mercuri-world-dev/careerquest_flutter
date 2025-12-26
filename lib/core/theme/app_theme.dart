import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Primary colors
  static const Color darkBlue = Color(0xFF20316D);
  static const Color deepPurple = Color(0xFF442079);
  static const Color violet = Color(0xFF9E88E8);
  static const Color cyanAccent = Color(0xFF88F9FF);

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
    color: Colors.white,
    fontSize: 64,
    fontWeight: FontWeight.w800,
    height: 1.0,
  );

  static const TextStyle label = TextStyle(
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
  static const Color cyanAccent = AppTheme.cyanAccent;

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

  static const String displayFont = 'Futura_PT';
  static const String uiFont = 'Alte_Haas_Grotesk';

  static const TextStyle display = TextStyle(
    fontFamily: displayFont,
    fontSize: 64,
    fontWeight: FontWeight.w800,
    height: 1.0,
    color: CQColors.white,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: uiFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: CQColors.darkBlue,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: uiFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: CQColors.darkBlue,
  );

  static const TextStyle body = TextStyle(
    fontFamily: uiFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CQColors.darkBlue,
  );

  static const TextStyle label = TextStyle(
    fontFamily: uiFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: CQColors.darkBlue,
  );

  static const TextStyle button = TextStyle(
    fontFamily: uiFont,
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
