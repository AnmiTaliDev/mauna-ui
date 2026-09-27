import 'dart:ui' show Color;

abstract final class MaunaAccents {
  static const Color steelBlue = Color(0xFF3B6FA8);

  static const Color graphite = Color(0xFF5A5D66);

  static const Color coolTeal = Color(0xFF2B8C7E);

  static const Color indigo = Color(0xFF5B5FC7);
}

abstract final class MaunaLightColors {
  static const Color bgCanvas = Color(0xFFF8FAFC);

  static const Color bgChrome = Color(0xFFEEF2F6);

  static const Color textPrimary = Color(0xFF111827);

  static const Color textSecondary = Color(0xFF64748B);

  static const Color line = Color(0xFFDCE3EB);

  static const Color accent = MaunaAccents.steelBlue;

  static const double popupShadowOpacity = 0.08;
}

abstract final class MaunaDarkColors {
  static const Color bgCanvas = Color(0xFF15181E);

  static const Color bgChrome = Color(0xFF1D2128);

  static const Color textPrimary = Color(0xFFEAEBED);

  static const Color textSecondary = Color(0xFF8B94A0);

  static const Color line = Color(0xFF2E3440);

  static const Color accent = Color(0xFF5B8FC7);

  static const double popupShadowOpacity = 0.04;
}

abstract final class MaunaFonts {
  static const String courierPrime = 'Courier Prime';

  static const String jetBrainsMono = 'JetBrains Mono';

  static const String inter = 'Inter';
}

abstract final class MaunaLineHeights {
  static const double doc = 1.6;

  static const double ui = 1.3;
}

abstract final class MaunaRadii {
  static const double sm = 4;

  static const double lg = 8;
}
