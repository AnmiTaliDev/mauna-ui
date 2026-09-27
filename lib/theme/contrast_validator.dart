import 'dart:math' as math;
import 'dart:ui' show Color;

const double wcagAaNormalText = 4.5;

double contrastRatio(Color a, Color b) {
  final double la = a.computeLuminance();
  final double lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

bool meetsWcagAa(Color text, Color background) {
  return contrastRatio(text, background) >= wcagAaNormalText;
}
