import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'contrast_validator.dart';
import 'mauna_motion.dart';
import 'mauna_spacing.dart';
import 'mauna_theme_presets.dart';
import 'mauna_typography.dart';

@immutable
class MaunaThemeData extends ThemeExtension<MaunaThemeData> {
  MaunaThemeData({
    required this.brightness,
    required this.bgCanvas,
    required this.bgChrome,
    required this.textPrimary,
    required this.textSecondary,
    required this.line,
    required this.accent,
    required this.fontDoc,
    required this.fontUi,
    required this.lineHeightDoc,
    required this.lineHeightUi,
    required this.radiusSm,
    required this.radiusLg,
    required this.popupShadowOpacity,
    this.typeScale = MaunaTypeScale.standard,
    this.spacing = MaunaSpacing.standard,
    this.motion = MaunaMotion.standard,
    this.metrics = MaunaMetrics.standard,
  }) : assert(
         meetsWcagAa(textPrimary, bgCanvas),
         'text.primary on bg.canvas is below WCAG AA 4.5:1',
       ),
       assert(
         meetsWcagAa(textPrimary, bgChrome),
         'text.primary on bg.chrome is below WCAG AA 4.5:1',
       ),
       assert(
         meetsWcagAa(textSecondary, bgCanvas),
         'text.secondary on bg.canvas is below WCAG AA 4.5:1',
       ),
       assert(
         meetsWcagAa(textSecondary, bgChrome),
         'text.secondary on bg.chrome is below WCAG AA 4.5:1',
       ),
       assert(
         radiusSm <= maxRadius && radiusLg <= maxRadius,
         'Radii above 8px are not used in Mauna',
       );

  factory MaunaThemeData.light({Color accent = MaunaLightColors.accent}) {
    return MaunaThemeData(
      brightness: Brightness.light,
      bgCanvas: MaunaLightColors.bgCanvas,
      bgChrome: MaunaLightColors.bgChrome,
      textPrimary: MaunaLightColors.textPrimary,
      textSecondary: MaunaLightColors.textSecondary,
      line: MaunaLightColors.line,
      accent: accent,
      fontDoc: MaunaFonts.courierPrime,
      fontUi: MaunaFonts.inter,
      lineHeightDoc: MaunaLineHeights.doc,
      lineHeightUi: MaunaLineHeights.ui,
      radiusSm: MaunaRadii.sm,
      radiusLg: MaunaRadii.lg,
      popupShadowOpacity: MaunaLightColors.popupShadowOpacity,
    );
  }

  factory MaunaThemeData.dark({Color accent = MaunaDarkColors.accent}) {
    return MaunaThemeData(
      brightness: Brightness.dark,
      bgCanvas: MaunaDarkColors.bgCanvas,
      bgChrome: MaunaDarkColors.bgChrome,
      textPrimary: MaunaDarkColors.textPrimary,
      textSecondary: MaunaDarkColors.textSecondary,
      line: MaunaDarkColors.line,
      accent: accent,
      fontDoc: MaunaFonts.courierPrime,
      fontUi: MaunaFonts.inter,
      lineHeightDoc: MaunaLineHeights.doc,
      lineHeightUi: MaunaLineHeights.ui,
      radiusSm: MaunaRadii.sm,
      radiusLg: MaunaRadii.lg,
      popupShadowOpacity: MaunaDarkColors.popupShadowOpacity,
    );
  }

  factory MaunaThemeData.sepia({Color accent = MaunaSepiaColors.accent}) {
    return MaunaThemeData(
      brightness: Brightness.light,
      bgCanvas: MaunaSepiaColors.bgCanvas,
      bgChrome: MaunaSepiaColors.bgChrome,
      textPrimary: MaunaSepiaColors.textPrimary,
      textSecondary: MaunaSepiaColors.textSecondary,
      line: MaunaSepiaColors.line,
      accent: accent,
      fontDoc: MaunaFonts.courierPrime,
      fontUi: MaunaFonts.inter,
      lineHeightDoc: MaunaLineHeights.doc,
      lineHeightUi: MaunaLineHeights.ui,
      radiusSm: MaunaRadii.sm,
      radiusLg: MaunaRadii.lg,
      popupShadowOpacity: MaunaSepiaColors.popupShadowOpacity,
    );
  }

  factory MaunaThemeData.midnight({Color accent = MaunaMidnightColors.accent}) {
    return MaunaThemeData(
      brightness: Brightness.dark,
      bgCanvas: MaunaMidnightColors.bgCanvas,
      bgChrome: MaunaMidnightColors.bgChrome,
      textPrimary: MaunaMidnightColors.textPrimary,
      textSecondary: MaunaMidnightColors.textSecondary,
      line: MaunaMidnightColors.line,
      accent: accent,
      fontDoc: MaunaFonts.courierPrime,
      fontUi: MaunaFonts.inter,
      lineHeightDoc: MaunaLineHeights.doc,
      lineHeightUi: MaunaLineHeights.ui,
      radiusSm: MaunaRadii.sm,
      radiusLg: MaunaRadii.lg,
      popupShadowOpacity: MaunaMidnightColors.popupShadowOpacity,
    );
  }

  factory MaunaThemeData.fromJson(Map<String, Object?> json) {
    return MaunaThemeData(
      brightness: Brightness.values.byName(json['brightness']! as String),
      bgCanvas: _colorFromHex(json['bg_canvas']! as String),
      bgChrome: _colorFromHex(json['bg_chrome']! as String),
      textPrimary: _colorFromHex(json['text_primary']! as String),
      textSecondary: _colorFromHex(json['text_secondary']! as String),
      line: _colorFromHex(json['line']! as String),
      accent: _colorFromHex(json['accent']! as String),
      fontDoc: json['font_doc']! as String,
      fontUi: json['font_ui']! as String,
      lineHeightDoc: (json['line_height_doc']! as num).toDouble(),
      lineHeightUi: (json['line_height_ui']! as num).toDouble(),
      radiusSm: (json['radius_sm']! as num).toDouble(),
      radiusLg: (json['radius_lg']! as num).toDouble(),
      popupShadowOpacity: (json['popup_shadow_opacity']! as num).toDouble(),
      typeScale: MaunaTypeScale.fromJson(json['type']! as Map<String, Object?>),
      spacing: MaunaSpacing.fromJson(json['space']! as Map<String, Object?>),
      motion: MaunaMotion.fromJson(json['motion']! as Map<String, Object?>),
      metrics: MaunaMetrics.fromJson(json['metrics']! as Map<String, Object?>),
    );
  }

  static const double maxRadius = MaunaRadii.lg;

  static MaunaThemeData of(BuildContext context) {
    return Theme.of(context).extension<MaunaThemeData>()!;
  }

  final Brightness brightness;

  final Color bgCanvas;

  final Color bgChrome;

  final Color textPrimary;

  final Color textSecondary;

  final Color line;

  final Color accent;

  final String fontDoc;

  final String fontUi;

  final double lineHeightDoc;

  final double lineHeightUi;

  final double radiusSm;

  final double radiusLg;

  final double popupShadowOpacity;

  final MaunaTypeScale typeScale;

  final MaunaSpacing spacing;

  final MaunaMotion motion;

  final MaunaMetrics metrics;

  BoxShadow get popupShadow => BoxShadow(
    color: const Color(0xFF000000).withValues(alpha: popupShadowOpacity),
    offset: Offset(0, metrics.popupShadowOffsetY),
    blurRadius: metrics.popupShadowBlur,
  );

  Color get selectionColor =>
      accent.withValues(alpha: metrics.selectionOpacity);

  ThemeData toMaterialTheme() {
    final ColorScheme base = brightness == Brightness.light
        ? const ColorScheme.light()
        : const ColorScheme.dark();
    return ThemeData(
      brightness: brightness,
      colorScheme: base.copyWith(
        primary: accent,
        onPrimary: bgCanvas,
        secondary: textSecondary,
        onSecondary: bgCanvas,
        surface: bgCanvas,
        onSurface: textPrimary,
        surfaceContainer: bgChrome,
        outline: line,
        outlineVariant: line,
      ),
      scaffoldBackgroundColor: bgCanvas,
      canvasColor: bgChrome,
      dividerColor: line,
      fontFamily: fontUi,
      splashFactory: NoSplash.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: selectionColor,
      ),
      extensions: <ThemeExtension<dynamic>>[this],
    );
  }

  @override
  MaunaThemeData copyWith({
    Brightness? brightness,
    Color? bgCanvas,
    Color? bgChrome,
    Color? textPrimary,
    Color? textSecondary,
    Color? line,
    Color? accent,
    String? fontDoc,
    String? fontUi,
    double? lineHeightDoc,
    double? lineHeightUi,
    double? radiusSm,
    double? radiusLg,
    double? popupShadowOpacity,
    MaunaTypeScale? typeScale,
    MaunaSpacing? spacing,
    MaunaMotion? motion,
    MaunaMetrics? metrics,
  }) {
    return MaunaThemeData(
      brightness: brightness ?? this.brightness,
      bgCanvas: bgCanvas ?? this.bgCanvas,
      bgChrome: bgChrome ?? this.bgChrome,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      fontDoc: fontDoc ?? this.fontDoc,
      fontUi: fontUi ?? this.fontUi,
      lineHeightDoc: lineHeightDoc ?? this.lineHeightDoc,
      lineHeightUi: lineHeightUi ?? this.lineHeightUi,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusLg: radiusLg ?? this.radiusLg,
      popupShadowOpacity: popupShadowOpacity ?? this.popupShadowOpacity,
      typeScale: typeScale ?? this.typeScale,
      spacing: spacing ?? this.spacing,
      motion: motion ?? this.motion,
      metrics: metrics ?? this.metrics,
    );
  }

  @override
  MaunaThemeData lerp(MaunaThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    final bool first = t < 0.5;
    return MaunaThemeData._unchecked(
      brightness: first ? brightness : other.brightness,
      bgCanvas: Color.lerp(bgCanvas, other.bgCanvas, t)!,
      bgChrome: Color.lerp(bgChrome, other.bgChrome, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      fontDoc: first ? fontDoc : other.fontDoc,
      fontUi: first ? fontUi : other.fontUi,
      lineHeightDoc: lerpDouble(lineHeightDoc, other.lineHeightDoc, t)!,
      lineHeightUi: lerpDouble(lineHeightUi, other.lineHeightUi, t)!,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t)!,
      popupShadowOpacity: lerpDouble(
        popupShadowOpacity,
        other.popupShadowOpacity,
        t,
      )!,
      typeScale: MaunaTypeScale.lerp(typeScale, other.typeScale, t),
      spacing: MaunaSpacing.lerp(spacing, other.spacing, t),
      motion: first ? motion : other.motion,
      metrics: MaunaMetrics.lerp(metrics, other.metrics, t),
    );
  }

  const MaunaThemeData._unchecked({
    required this.brightness,
    required this.bgCanvas,
    required this.bgChrome,
    required this.textPrimary,
    required this.textSecondary,
    required this.line,
    required this.accent,
    required this.fontDoc,
    required this.fontUi,
    required this.lineHeightDoc,
    required this.lineHeightUi,
    required this.radiusSm,
    required this.radiusLg,
    required this.popupShadowOpacity,
    required this.typeScale,
    required this.spacing,
    required this.motion,
    required this.metrics,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'brightness': brightness.name,
      'bg_canvas': _colorToHex(bgCanvas),
      'bg_chrome': _colorToHex(bgChrome),
      'text_primary': _colorToHex(textPrimary),
      'text_secondary': _colorToHex(textSecondary),
      'line': _colorToHex(line),
      'accent': _colorToHex(accent),
      'font_doc': fontDoc,
      'font_ui': fontUi,
      'line_height_doc': lineHeightDoc,
      'line_height_ui': lineHeightUi,
      'radius_sm': radiusSm,
      'radius_lg': radiusLg,
      'popup_shadow_opacity': popupShadowOpacity,
      'type': typeScale.toJson(),
      'space': spacing.toJson(),
      'motion': motion.toJson(),
      'metrics': metrics.toJson(),
    };
  }
}

Color _colorFromHex(String hex) {
  final String digits = hex.startsWith('#') ? hex.substring(1) : hex;
  if (digits.length != 6 && digits.length != 8) {
    throw FormatException('Expected #RRGGBB or #AARRGGBB', hex);
  }
  final int value = int.parse(digits, radix: 16);
  return Color(digits.length == 6 ? 0xFF000000 | value : value);
}

String _colorToHex(Color color) {
  final int argb = color.toARGB32();
  final bool opaque = (argb >>> 24) == 0xFF;
  final String digits = opaque
      ? (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0')
      : argb.toRadixString(16).padLeft(8, '0');
  return '#${digits.toUpperCase()}';
}
