import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import 'mauna_svg_path.dart';

abstract final class MaunaGlyphs {
  static const double gridSize = 24;

  static Path _circle(double cx, double cy, double r) {
    return Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
  }

  static Path file() {
    return parseSvgPath(
      'M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z'
      'M14 2L14 8L20 8',
    );
  }

  static Path save() {
    return parseSvgPath(
      'M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z'
      'M17 21L17 13L7 13L7 21M7 3L7 8L15 8',
    );
  }

  static Path search() {
    return _circle(11, 11, 8)
      ..addPath(parseSvgPath('M21 21L16.65 16.65'), Offset.zero);
  }

  static Path focus() {
    return parseSvgPath(
      'M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3'
      'M3 16v3a2 2 0 0 0 2 2h3',
    );
  }

  static Path download() {
    return parseSvgPath(
      'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'
      'M7 10L12 15L17 10M12 15L12 3',
    );
  }

  static Path menu() {
    return parseSvgPath('M3 12L21 12M3 6L21 6M3 18L21 18');
  }

  static Path settings() {
    return _circle(12, 12, 3)..addPath(
      parseSvgPath(
        'M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1'
        '-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21'
        'a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0'
        ' 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65'
        ' 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1'
        ' 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2'
        ' 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65'
        ' 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0'
        ' 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0'
        ' 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2'
        ' 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z',
      ),
      Offset.zero,
    );
  }

  static Path sidebar() {
    return Path()
      ..addRRect(RRect.fromLTRBR(3, 3, 21, 21, const Radius.circular(2)))
      ..addPath(parseSvgPath('M9 3L9 21'), Offset.zero);
  }

  static Path command() {
    return parseSvgPath('M4 17L10 11L4 5M12 19L20 19');
  }

  static Path chevronDown() {
    return parseSvgPath('M6 9L12 15L18 9');
  }

  static Path close() {
    return parseSvgPath('M18 6L6 18M6 6L18 18');
  }

  static Path check() {
    return parseSvgPath('M20 6L9 17L4 12');
  }

  static Path sun() {
    return _circle(12, 12, 5)..addPath(
      parseSvgPath(
        'M12 1L12 3M12 21L12 23M4.22 4.22L5.64 5.64M18.36 18.36L19.78 19.78'
        'M1 12L3 12M21 12L23 12M4.22 19.78L5.64 18.36M18.36 5.64L19.78 4.22',
      ),
      Offset.zero,
    );
  }

  static Path moon() {
    return parseSvgPath('M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z');
  }
}

class MaunaIcon extends StatelessWidget {
  const MaunaIcon(this.glyph, {super.key, required this.color, this.size});

  final Path glyph;

  final Color color;

  final double? size;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return CustomPaint(
      size: Size.square(size ?? theme.metrics.iconSize),
      painter: _GlyphPainter(
        glyph: glyph,
        color: color,
        strokeWidth: theme.metrics.iconStrokeWidth,
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter({
    required this.glyph,
    required this.color,
    required this.strokeWidth,
  });

  final Path glyph;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.shortestSide / MaunaGlyphs.gridSize;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    canvas.save();
    canvas.scale(scale);
    canvas.drawPath(glyph, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GlyphPainter oldDelegate) {
    return oldDelegate.glyph != glyph ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
