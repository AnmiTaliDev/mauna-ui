import 'dart:ui' show lerpDouble;

import 'package:flutter/painting.dart';

import 'mauna_theme_data.dart';

class MaunaTypeScale {
  const MaunaTypeScale({
    required this.caption,
    required this.ui,
    required this.doc,
    required this.heading,
    required this.title,
    required this.lineHeightTitle,
  });

  static const MaunaTypeScale standard = MaunaTypeScale(
    caption: 12,
    ui: 14,
    doc: 16,
    heading: 20,
    title: 28,
    lineHeightTitle: 1.25,
  );

  final double caption;

  final double ui;

  final double doc;

  final double heading;

  final double title;

  final double lineHeightTitle;

  factory MaunaTypeScale.fromJson(Map<String, Object?> json) {
    double read(String key) => (json[key]! as num).toDouble();
    return MaunaTypeScale(
      caption: read('caption'),
      ui: read('ui'),
      doc: read('doc'),
      heading: read('heading'),
      title: read('title'),
      lineHeightTitle: read('line_height_title'),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'caption': caption,
      'ui': ui,
      'doc': doc,
      'heading': heading,
      'title': title,
      'line_height_title': lineHeightTitle,
    };
  }

  static MaunaTypeScale lerp(MaunaTypeScale a, MaunaTypeScale b, double t) {
    return MaunaTypeScale(
      caption: lerpDouble(a.caption, b.caption, t)!,
      ui: lerpDouble(a.ui, b.ui, t)!,
      doc: lerpDouble(a.doc, b.doc, t)!,
      heading: lerpDouble(a.heading, b.heading, t)!,
      title: lerpDouble(a.title, b.title, t)!,
      lineHeightTitle: lerpDouble(a.lineHeightTitle, b.lineHeightTitle, t)!,
    );
  }
}

extension MaunaTextStyles on MaunaThemeData {
  TextStyle get captionStyle => TextStyle(
    fontFamily: fontUi,
    fontSize: typeScale.caption,
    height: lineHeightUi,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  TextStyle get uiStyle => TextStyle(
    fontFamily: fontUi,
    fontSize: typeScale.ui,
    height: lineHeightUi,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  TextStyle get docStyle => TextStyle(
    fontFamily: fontDoc,
    fontSize: typeScale.doc,
    height: lineHeightDoc,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  TextStyle get headingStyle => TextStyle(
    fontFamily: fontUi,
    fontSize: typeScale.heading,
    height: lineHeightUi,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  TextStyle get titleStyle => TextStyle(
    fontFamily: fontUi,
    fontSize: typeScale.title,
    height: typeScale.lineHeightTitle,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
}
