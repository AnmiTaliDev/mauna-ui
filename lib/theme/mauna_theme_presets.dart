import 'dart:ui' show Color;

class MaunaAccent {
  const MaunaAccent({required this.light, required this.dark});

  final Color light;

  final Color dark;
}

abstract final class MaunaAccents {
  static const MaunaAccent steelBlue = MaunaAccent(
    light: Color(0xFF36669B),
    dark: Color(0xFF5B8FC7),
  );

  static const MaunaAccent graphite = MaunaAccent(
    light: Color(0xFF5A5D66),
    dark: Color(0xFF858994),
  );

  static const MaunaAccent coolTeal = MaunaAccent(
    light: Color(0xFF226F64),
    dark: Color(0xFF2F9A8A),
  );

  static const MaunaAccent indigo = MaunaAccent(
    light: Color(0xFF5156C4),
    dark: Color(0xFF7F82D3),
  );
}

abstract final class MaunaLightColors {
  static const Color bgCanvas = Color(0xFFF8FAFC);

  static const Color bgChrome = Color(0xFFEEF2F6);

  static const Color textPrimary = Color(0xFF111827);

  static const Color textSecondary = Color(0xFF5F6E84);

  static const Color line = Color(0xFFDCE3EB);

  static const Color accent = Color(0xFF36669B);

  static const Color textOnAccent = Color(0xFFFBFAF7);

  static const double popupShadowOpacity = 0.08;
}

abstract final class MaunaDarkColors {
  static const Color bgCanvas = Color(0xFF15181E);

  static const Color bgChrome = Color(0xFF1D2128);

  static const Color textPrimary = Color(0xFFEAEBED);

  static const Color textSecondary = Color(0xFF8B94A0);

  static const Color line = Color(0xFF2E3440);

  static const Color accent = Color(0xFF5B8FC7);

  static const Color textOnAccent = Color(0xFF1C1B19);

  static const double popupShadowOpacity = 0.04;
}

abstract final class MaunaSepiaColors {
  static const Color bgCanvas = Color(0xFFF4EEE1);

  static const Color bgChrome = Color(0xFFEAE2D1);

  static const Color textPrimary = Color(0xFF2B2620);

  static const Color textSecondary = Color(0xFF6D6254);

  static const Color line = Color(0xFFDCD2BE);

  static const Color accent = Color(0xFF36669B);

  static const Color textOnAccent = Color(0xFFFBFAF7);

  static const double popupShadowOpacity = 0.08;
}

abstract final class MaunaMidnightColors {
  static const Color bgCanvas = Color(0xFF0E1117);

  static const Color bgChrome = Color(0xFF151A23);

  static const Color textPrimary = Color(0xFFDDE3EC);

  static const Color textSecondary = Color(0xFF7F8A9A);

  static const Color line = Color(0xFF252C38);

  static const Color accent = Color(0xFF5B8FC7);

  static const Color textOnAccent = Color(0xFF1C1B19);

  static const double popupShadowOpacity = 0.04;
}

abstract final class MaunaFonts {
  static const String courierPrime = 'Courier Prime';

  static const String jetBrainsMono = 'JetBrains Mono';

  static const String inter = 'Inter';

  static const List<String> docFallback = <String>[
    'Courier New',
    'Courier',
    'Liberation Mono',
    'DejaVu Sans Mono',
    'monospace',
  ];

  static const List<String> uiFallback = <String>[
    'Segoe UI',
    'Roboto',
    'Cantarell',
    'Noto Sans',
    'sans-serif',
  ];
}

abstract final class MaunaLineHeights {
  static const double doc = 1.6;

  static const double ui = 1.3;
}

abstract final class MaunaRadii {
  static const double sm = 4;

  static const double lg = 8;
}
