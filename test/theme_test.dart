import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mauna/mauna.dart';

void main() {
  test('contrast ratio matches WCAG reference values', () {
    expect(
      contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
  });

  test('every preset and accent pair passes WCAG AA on its backgrounds', () {
    final List<MaunaThemeData> presets = <MaunaThemeData>[
      MaunaThemeData.light(),
      MaunaThemeData.dark(),
      MaunaThemeData.sepia(),
      MaunaThemeData.midnight(),
    ];
    const List<MaunaAccent> accents = <MaunaAccent>[
      MaunaAccents.steelBlue,
      MaunaAccents.graphite,
      MaunaAccents.coolTeal,
      MaunaAccents.indigo,
    ];
    for (final MaunaThemeData theme in presets) {
      expect(meetsWcagAa(theme.textSecondary, theme.bgChrome), isTrue);
      for (final MaunaAccent accent in accents) {
        final Color color = theme.brightness == Brightness.light
            ? accent.light
            : accent.dark;
        expect(meetsWcagAa(color, theme.bgCanvas), isTrue);
        expect(meetsWcagAa(color, theme.bgChrome), isTrue);
      }
    }
  });

  test('presets build with their values', () {
    final MaunaThemeData light = MaunaThemeData.light();
    final MaunaThemeData dark = MaunaThemeData.dark();
    expect(light.bgCanvas, const Color(0xFFF8FAFC));
    expect(dark.textSecondary, const Color(0xFF8B94A0));
    expect(light.accent, MaunaAccents.steelBlue.light);
    expect(dark.popupShadowOpacity, light.popupShadowOpacity / 2);
    expect(
      MaunaThemeData.light(accent: MaunaAccents.coolTeal.light).accent,
      MaunaAccents.coolTeal.light,
    );
  });

  test('low contrast theme fails the debug assert', () {
    expect(
      () =>
          MaunaThemeData.light().copyWith(textPrimary: const Color(0xFFCCCCCC)),
      throwsAssertionError,
    );
  });

  test('radius above 8px fails the debug assert', () {
    expect(
      () => MaunaThemeData.light().copyWith(radiusLg: 12),
      throwsAssertionError,
    );
  });

  test('JSON round trip keeps every field', () {
    final MaunaThemeData source = MaunaThemeData.dark(
      accent: MaunaAccents.indigo.dark,
    );
    final Map<String, Object?> json = source.toJson();
    expect(json['accent'], '#7F82D3');
    expect(json['bg_canvas'], '#15181E');
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
