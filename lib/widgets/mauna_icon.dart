import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';

abstract final class MaunaGlyphs {
  static const double gridSize = 24;

  static Path sidebar() {
    return Path()
      ..addRRect(RRect.fromLTRBR(3, 4, 21, 20, const Radius.circular(2)))
      ..moveTo(9, 4)
      ..lineTo(9, 20);
  }

  static Path focus() {
    return Path()
      ..moveTo(3, 8)
      ..lineTo(3, 3)
      ..lineTo(8, 3)
      ..moveTo(16, 3)
      ..lineTo(21, 3)
      ..lineTo(21, 8)
      ..moveTo(21, 16)
      ..lineTo(21, 21)
      ..lineTo(16, 21)
      ..moveTo(8, 21)
      ..lineTo(3, 21)
      ..lineTo(3, 16);
  }

  static Path command() {
    return Path()
      ..moveTo(4, 17)
      ..lineTo(10, 11)
      ..lineTo(4, 5)
      ..moveTo(12, 19)
      ..lineTo(20, 19);
  }

  static Path search() {
    return Path()
      ..addOval(Rect.fromCircle(center: const Offset(11, 11), radius: 7))
      ..moveTo(16, 16)
      ..lineTo(21, 21);
  }

  static Path sun() {
    final Path path = Path()
      ..addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 4));
    for (int i = 0; i < 8; i++) {
      final double angle = i * math.pi / 4;
      final Offset direction = Offset(math.cos(angle), math.sin(angle));
      final Offset start = const Offset(12, 12) + direction * 7;
      final Offset end = const Offset(12, 12) + direction * 9.5;
      path
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);
    }
    return path;
  }

  static Path moon() {
    return Path()
      ..moveTo(20, 14.5)
      ..arcToPoint(
        const Offset(9.5, 4),
        radius: const Radius.circular(8.5),
        largeArc: true,
      )
      ..arcToPoint(
        const Offset(20, 14.5),
        radius: const Radius.circular(6.5),
        clockwise: false,
      )
      ..close();
  }
}

class MaunaIcon extends StatelessWidget {
  const MaunaIcon(this.glyph, {super.key, required this.color});

  final Path glyph;

  final Color color;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return CustomPaint(
      size: Size.square(theme.metrics.iconSize),
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
