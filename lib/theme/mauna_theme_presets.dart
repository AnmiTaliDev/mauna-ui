import 'dart:ui' show Color;

class MaunaAccent {
  const MaunaAccent({
    required this.light,
    required this.dark,
    required this.fill,
  });

  final Color light;

  final Color dark;

  final Color fill;
}

abstract final class MaunaAccents {
  static const MaunaAccent steelBlue = MaunaAccent(
    light: Color(0xFF0064CC),
    dark: Color(0xFF4DA3FF),
    fill: Color(0xFF0A68D8),
  );

  static const MaunaAccent graphite = MaunaAccent(
    light: Color(0xFF55555A),
    dark: Color(0xFFB0B0B6),
    fill: Color(0xFF6C6C72),
  );

  static const MaunaAccent coolTeal = MaunaAccent(
    light: Color(0xFF0C6B62),
    dark: Color(0xFF45C4B0),
    fill: Color(0xFF10766C),
  );

  static const MaunaAccent indigo = MaunaAccent(
    light: Color(0xFF4B45C6),
    dark: Color(0xFFA5A2FA),
    fill: Color(0xFF5651D2),
  );
}

abstract final class MaunaLightColors {
  static const Color bgCanvas = Color(0xFFFFFFFF);

  static const Color bgChrome = Color(0xFFF5F5F6);

  static const Color bgCard = Color(0xFFFFFFFF);

  static const Color bgControl = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1D1D1F);

  static const Color textSecondary = Color(0xFF68686D);

  static const Color line = Color(0xFFE5E5E7);

  static const Color fill = Color(0x0F000000);

  static const Color accent = Color(0xFF0064CC);

  static const Color textOnAccent = Color(0xFFFFFFFF);

  static const double popupShadowOpacity = 0.16;
}

abstract final class MaunaDarkColors {
  static const Color bgCanvas = Color(0xFF1E1E1F);

  static const Color bgChrome = Color(0xFF272729);

  static const Color bgCard = Color(0xFF303033);

  static const Color bgControl = Color(0xFF5E5E63);

  static const Color textPrimary = Color(0xFFE9E9EB);

  static const Color textSecondary = Color(0xFFA2A2A8);

  static const Color line = Color(0xFF39393C);

  static const Color fill = Color(0x14FFFFFF);

  static const Color accent = Color(0xFF4DA3FF);

  static const Color textOnAccent = Color(0xFFFFFFFF);

  static const double popupShadowOpacity = 0.4;
}

abstract final class MaunaSepiaColors {
  static const Color bgCanvas = Color(0xFFF9F4E9);

  static const Color bgChrome = Color(0xFFF0EADC);

  static const Color bgCard = Color(0xFFFCF8F0);

  static const Color bgControl = Color(0xFFFCF8F0);

  static const Color textPrimary = Color(0xFF2D2820);

  static const Color textSecondary = Color(0xFF6A5F4E);

  static const Color line = Color(0xFFE3DAC8);

  static const Color fill = Color(0x12503C14);

  static const Color accent = Color(0xFF0064CC);

  static const Color textOnAccent = Color(0xFFFFFFFF);

  static const double popupShadowOpacity = 0.16;
}

abstract final class MaunaMidnightColors {
  static const Color bgCanvas = Color(0xFF101216);

  static const Color bgChrome = Color(0xFF181B21);

  static const Color bgCard = Color(0xFF21252D);

  static const Color bgControl = Color(0xFF4A505C);

  static const Color textPrimary = Color(0xFFE0E5ED);

  static const Color textSecondary = Color(0xFF98A0AE);

  static const Color line = Color(0xFF2A2F39);

  static const Color fill = Color(0x14FFFFFF);

  static const Color accent = Color(0xFF4DA3FF);

  static const Color textOnAccent = Color(0xFFFFFFFF);

  static const double popupShadowOpacity = 0.45;
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
  static const double sm = 6;

  static const double lg = 10;
}
