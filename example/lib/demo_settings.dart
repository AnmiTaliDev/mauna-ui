import 'package:flutter/widgets.dart';
import 'package:mauna/mauna.dart';

enum DemoPreset {
  paper('Paper'),
  sepia('Sepia'),
  ink('Ink'),
  midnight('Midnight'),
  system('System');

  const DemoPreset(this.label);

  final String label;
}

class DemoAccent {
  const DemoAccent(this.name, this.value);

  DemoAccent.custom(Color color)
    : name = customName,
      value = MaunaAccent(light: color, dark: color);

  static const String customName = 'Custom';

  static const List<DemoAccent> presets = <DemoAccent>[
    DemoAccent('Steel blue', MaunaAccents.steelBlue),
    DemoAccent('Graphite', MaunaAccents.graphite),
    DemoAccent('Cool teal', MaunaAccents.coolTeal),
    DemoAccent('Indigo', MaunaAccents.indigo),
  ];

  final String name;

  final MaunaAccent value;
}

class DemoSettings {
  const DemoSettings({required this.preset, required this.accent});

  final DemoPreset preset;

  final DemoAccent accent;

  DemoSettings copyWith({DemoPreset? preset, DemoAccent? accent}) {
    return DemoSettings(
      preset: preset ?? this.preset,
      accent: accent ?? this.accent,
    );
  }
}

String colorToHex(Color color) {
  final int rgb = color.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

Color? parseHex(String input) {
  if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(input)) {
    return null;
  }
  return Color(0xFF000000 | int.parse(input.substring(1), radix: 16));
}
