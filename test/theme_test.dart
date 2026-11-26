import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mauna/mauna.dart';

void main() {
  test('type scale and metrics copy one value', () {
    final MaunaTypeScale type = MaunaTypeScale.standard.copyWith(doc: 20);
    expect(type.doc, 20);
    expect(type.ui, MaunaTypeScale.standard.ui);
    final MaunaMetrics metrics = MaunaMetrics.standard.copyWith(
      documentColumnWidth: 700,
    );
    expect(metrics.documentColumnWidth, 700);
    expect(metrics.sidebarWidth, MaunaMetrics.standard.sidebarWidth);
  });

  test('contrast ratio matches WCAG reference values', () {
    expect(
      contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
  });

  test('every preset and accent passes WCAG AA', () {
    const List<MaunaAccent> accents = <MaunaAccent>[
      MaunaAccents.steelBlue,
      MaunaAccents.graphite,
      MaunaAccents.coolTeal,
      MaunaAccents.indigo,
    ];
    for (final MaunaAccent accent in accents) {
      for (final MaunaThemeData theme in <MaunaThemeData>[
        MaunaThemeData.light(accent: accent),
        MaunaThemeData.dark(accent: accent),
        MaunaThemeData.sepia(accent: accent),
        MaunaThemeData.midnight(accent: accent),
      ]) {
        for (final Color background in <Color>[
          theme.bgCanvas,
          theme.bgChrome,
          theme.bgCard,
        ]) {
          expect(meetsWcagAa(theme.textPrimary, background), isTrue);
          expect(meetsWcagAa(theme.textSecondary, background), isTrue);
          expect(meetsWcagAa(theme.accent, background), isTrue);
        }
        expect(meetsWcagAa(theme.textOnAccent, theme.accentFill), isTrue);
        expect(
          meetsWcagAa(
            theme.textPrimary,
            Color.alphaBlend(theme.selectionColor, theme.bgCanvas),
          ),
          isTrue,
        );
      }
    }
  });

  test('presets build with their values', () {
    final MaunaThemeData light = MaunaThemeData.light();
    final MaunaThemeData dark = MaunaThemeData.dark();
    expect(light.bgCanvas, const Color(0xFFFFFFFF));
    expect(dark.textSecondary, const Color(0xFFA2A2A8));
    expect(light.accent, MaunaAccents.steelBlue.light);
    expect(dark.accent, MaunaAccents.steelBlue.dark);
    final MaunaThemeData teal = MaunaThemeData.light(
      accent: MaunaAccents.coolTeal,
    );
    expect(teal.accent, MaunaAccents.coolTeal.light);
    expect(teal.accentFill, MaunaAccents.coolTeal.fill);
  });

  test('low contrast theme fails the debug assert', () {
    expect(
      () =>
          MaunaThemeData.light().copyWith(textPrimary: const Color(0xFFCCCCCC)),
      throwsAssertionError,
    );
  });

  test('radius above 10px fails the debug assert', () {
    expect(
      () => MaunaThemeData.light().copyWith(radiusLg: 14),
      throwsAssertionError,
    );
  });

  test('JSON round trip keeps every field', () {
    final MaunaThemeData source = MaunaThemeData.dark(
      accent: MaunaAccents.indigo,
    );
    final Map<String, Object?> json = source.toJson();
    expect(json['accent'], '#A5A2FA');
    expect(json['bg_canvas'], '#1E1E1F');
    final MaunaThemeData restored = MaunaThemeData.fromJson(json);
    expect(restored.toJson(), json);
  });

  test('fromJson rejects malformed colors', () {
    final Map<String, Object?> json = MaunaThemeData.light().toJson()
      ..['accent'] = '#12345';
    expect(() => MaunaThemeData.fromJson(json), throwsFormatException);
  });

  test('lerp interpolates colors', () {
    final MaunaThemeData light = MaunaThemeData.light();
    final MaunaThemeData dark = MaunaThemeData.dark();
    expect(light.lerp(dark, 0).bgCanvas, light.bgCanvas);
    expect(light.lerp(dark, 1).bgCanvas, dark.bgCanvas);
    expect(light.lerp(dark, 1).brightness, Brightness.dark);
  });

  test('material theme exposes the extension', () {
    final ThemeData material = MaunaThemeData.light().toMaterialTheme();
    expect(material.extension<MaunaThemeData>(), isNotNull);
    expect(material.colorScheme.primary, MaunaLightColors.accent);
  });
}
