import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_theme_presets.dart';
import '../theme/mauna_typography.dart';

class MaunaTextController extends TextEditingController {
  MaunaTextController({super.text, this.markup = false});

  final bool markup;

  static const String titleMarker = '# ';
  static const String headingMarker = '## ';
  static const double _hiddenFontSize = 0.01;
  static final RegExp _inline = RegExp(r'\*\*(.+?)\*\*|`([^`\n]+)`');

  List<TextRange> titleLines() {
    final List<TextRange> ranges = <TextRange>[];
    int lineStart = 0;
    while (lineStart <= text.length) {
      final int lineEnd = _lineEnd(lineStart);
      if (text.startsWith(titleMarker, lineStart) && lineEnd > lineStart) {
        ranges.add(TextRange(start: lineStart, end: lineEnd));
      }
      lineStart = lineEnd + 1;
    }
    return ranges;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final bool composing =
        withComposing &&
        value.isComposingRangeValid &&
        !value.composing.isCollapsed;
    if (composing) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final TextStyle base = style ?? theme.docStyle;
    final List<_Segment> segments = markup
        ? _markupSegments(theme, base)
        : <_Segment>[_Segment(0, text.length, base)];
    return TextSpan(
      style: base,
      children: _applySelection(segments, theme.textOnAccent),
    );
  }

  int _lineEnd(int lineStart) {
    final int newline = text.indexOf('\n', lineStart);
    return newline == -1 ? text.length : newline;
  }

  List<_Segment> _markupSegments(MaunaThemeData theme, TextStyle base) {
    final List<_Segment> segments = <_Segment>[];
    final TextSelection selection = value.selection;
    int lineStart = 0;
    while (lineStart <= text.length) {
      final int lineEnd = _lineEnd(lineStart);
      final bool active =
          selection.isValid &&
          selection.start <= lineEnd &&
          selection.end >= lineStart;
      TextStyle lineStyle = base;
      int markerLength = 0;
      if (lineEnd == lineStart && !active) {
        lineStyle = base.copyWith(height: theme.spacing.md / base.fontSize!);
      } else if (text.startsWith(titleMarker, lineStart)) {
        lineStyle = theme.titleStyle;
        markerLength = titleMarker.length;
      } else if (text.startsWith(headingMarker, lineStart)) {
        lineStyle = theme.headingStyle;
        markerLength = headingMarker.length;
      }
      final TextStyle markerStyle = active
          ? lineStyle.copyWith(color: theme.textSecondary)
          : lineStyle.copyWith(
              fontSize: _hiddenFontSize,
              color: theme.textPrimary.withValues(alpha: 0),
            );
      if (markerLength > 0) {
        segments.add(
          _Segment(lineStart, lineStart + markerLength, markerStyle),
        );
      }
      _addInline(
        segments,
        theme,
        lineStart + markerLength,
        lineEnd,
        lineStyle,
        markerStyle,
        markerLength > 0,
      );
      if (lineEnd < text.length) {
        segments.add(_Segment(lineEnd, lineEnd + 1, lineStyle));
      }
      lineStart = lineEnd + 1;
    }
    return segments;
  }

  void _addInline(
    List<_Segment> segments,
    MaunaThemeData theme,
    int start,
    int end,
    TextStyle lineStyle,
    TextStyle markerStyle,
    bool heading,
  ) {
    final String content = text.substring(start, end);
    int cursor = 0;
    for (final RegExpMatch match in _inline.allMatches(content)) {
      if (match.start > cursor) {
        segments.add(_Segment(start + cursor, start + match.start, lineStyle));
      }
      final bool bold = match.group(1) != null;
      final int markerLength = bold ? 2 : 1;
      final TextStyle inner = bold
          ? (heading
                ? lineStyle
                : lineStyle.copyWith(fontWeight: FontWeight.w700))
          : lineStyle.copyWith(
              fontFamily: theme.fontDoc,
              fontFamilyFallback: MaunaFonts.docFallback,
              fontSize: lineStyle.fontSize! * theme.typeScale.inlineCodeScale,
              backgroundColor: theme.bgChrome,
            );
      final int innerStart = start + match.start + markerLength;
      final int innerEnd = start + match.end - markerLength;
      segments
        ..add(_Segment(start + match.start, innerStart, markerStyle))
        ..add(_Segment(innerStart, innerEnd, inner))
        ..add(_Segment(innerEnd, start + match.end, markerStyle));
      cursor = match.end;
    }
    if (cursor < content.length) {
      segments.add(_Segment(start + cursor, end, lineStyle));
    }
  }

  List<TextSpan> _applySelection(List<_Segment> segments, Color selected) {
    final TextSelection selection = value.selection;
    final bool hasSelection = selection.isValid && !selection.isCollapsed;
    final List<TextSpan> spans = <TextSpan>[];
    for (final _Segment segment in segments) {
      if (!hasSelection ||
          segment.end <= selection.start ||
          segment.start >= selection.end) {
        spans.add(_span(segment.start, segment.end, segment.style));
        continue;
      }
      final int from = math.max(segment.start, selection.start);
      final int to = math.min(segment.end, selection.end);
      if (segment.start < from) {
        spans.add(_span(segment.start, from, segment.style));
      }
      spans.add(_span(from, to, segment.style.copyWith(color: selected)));
      if (to < segment.end) {
        spans.add(_span(to, segment.end, segment.style));
      }
    }
    return spans;
  }

  TextSpan _span(int start, int end, TextStyle style) {
    return TextSpan(text: text.substring(start, end), style: style);
  }
}

class _Segment {
  const _Segment(this.start, this.end, this.style);

  final int start;
  final int end;
  final TextStyle style;
}
