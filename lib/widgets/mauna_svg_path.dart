import 'dart:ui' show Offset, Path, Radius;

final RegExp _token = RegExp(r'[MmLlHhVvCcAaZz]|-?(?:\d+\.?\d*|\.\d+)');
final RegExp _command = RegExp(r'^[A-Za-z]$');

Path parseSvgPath(String data) {
  final List<String> tokens = <String>[
    for (final RegExpMatch match in _token.allMatches(data)) match.group(0)!,
  ];
  final Path path = Path();
  int index = 0;
  String command = 'M';
  double x = 0;
  double y = 0;
  double startX = 0;
  double startY = 0;

  double next() => double.parse(tokens[index++]);

  while (index < tokens.length) {
    if (_command.hasMatch(tokens[index])) {
      command = tokens[index++];
    }
    final bool relative = command == command.toLowerCase();
    final double baseX = relative ? x : 0;
    final double baseY = relative ? y : 0;
    switch (command.toUpperCase()) {
      case 'M':
        x = baseX + next();
        y = baseY + next();
        startX = x;
        startY = y;
        path.moveTo(x, y);
        command = relative ? 'l' : 'L';
      case 'L':
        x = baseX + next();
        y = baseY + next();
        path.lineTo(x, y);
      case 'H':
        x = baseX + next();
        path.lineTo(x, y);
      case 'V':
        y = baseY + next();
        path.lineTo(x, y);
      case 'C':
        final double x1 = baseX + next();
        final double y1 = baseY + next();
        final double x2 = baseX + next();
        final double y2 = baseY + next();
        x = baseX + next();
        y = baseY + next();
        path.cubicTo(x1, y1, x2, y2, x, y);
      case 'A':
        final double rx = next();
        final double ry = next();
        final double rotation = next();
        final bool largeArc = next() != 0;
        final bool clockwise = next() != 0;
        x = baseX + next();
        y = baseY + next();
        path.arcToPoint(
          Offset(x, y),
          radius: Radius.elliptical(rx, ry),
          rotation: rotation,
          largeArc: largeArc,
          clockwise: clockwise,
        );
      case 'Z':
        path.close();
        x = startX;
        y = startY;
    }
  }
  return path;
}
