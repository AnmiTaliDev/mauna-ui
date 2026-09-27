import 'package:flutter/animation.dart';

class MaunaMotion {
  const MaunaMotion({
    required this.fast,
    required this.base,
    required this.slow,
    required this.cursorBlink,
  });

  static const MaunaMotion standard = MaunaMotion(
    fast: Duration(milliseconds: 120),
    base: Duration(milliseconds: 200),
    slow: Duration(milliseconds: 320),
    cursorBlink: Duration(milliseconds: 530),
  );

  static const Curve fastCurve = Curves.easeOut;

  static const Curve baseCurve = Curves.easeInOut;

  static const Curve slowCurve = Curves.easeInOut;

  final Duration fast;

  final Duration base;

  final Duration slow;

  final Duration cursorBlink;

  factory MaunaMotion.fromJson(Map<String, Object?> json) {
    Duration read(String key) => Duration(milliseconds: json[key]! as int);
    return MaunaMotion(
      fast: read('fast_ms'),
      base: read('base_ms'),
      slow: read('slow_ms'),
      cursorBlink: read('cursor_blink_ms'),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'fast_ms': fast.inMilliseconds,
      'base_ms': base.inMilliseconds,
      'slow_ms': slow.inMilliseconds,
      'cursor_blink_ms': cursorBlink.inMilliseconds,
    };
  }
}
