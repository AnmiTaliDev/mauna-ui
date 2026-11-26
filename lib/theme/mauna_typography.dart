import 'dart:ui' show lerpDouble;

import 'package:flutter/painting.dart';

import 'mauna_theme_data.dart';
import 'mauna_theme_presets.dart';

class MaunaTypeScale {
  const MaunaTypeScale({
    required this.caption,
    required this.ui,
    required this.doc,
    required this.heading,
    required this.title,
    required this.lineHeightTitle,
    required this.labelLetterSpacing,
    required this.inlineCodeScale,
  });

  static const MaunaTypeScale standard = MaunaTypeScale(
    caption: 11,
    ui: 13,
    doc: 16,
    heading: 17,
    title: 26,
    lineHeightTitle: 1.25,
    labelLetterSpacing: 0,
    inlineCodeScale: 0.9,
  );

  final double caption;

  final double ui;

  final double doc;

  final double heading;

  final double title;

  final double lineHeightTitle;

  final double labelLetterSpacing;

  final double inlineCodeScale;

  factory MaunaTypeScale.fromJson(Map<String, Object?> json) {
    double read(String key) => (json[key]! as num).toDouble();
    return MaunaTypeScale(
      caption: read('caption'),
      ui: read('ui'),
      doc: read('doc'),
      heading: read('heading'),
      title: read('title'),
      lineHeightTitle: read('line_height_title'),
      labelLetterSpacing: read('label_letter_spacing'),
      inlineCodeScale: read('inline_code_scale'),
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
      'label_letter_spacing': labelLetterSpacing,
      'inline_code_scale': inlineCodeScale,
    };
  }

  MaunaTypeScale copyWith({
    double? caption,
    double? ui,
    double? doc,
    double? heading,
    double? title,
    double? lineHeightTitle,
    double? labelLetterSpacing,
    double? inlineCodeScale,
  }) {
    return MaunaTypeScale(
      caption: caption ?? this.caption,
      ui: ui ?? this.ui,
      doc: doc ?? this.doc,
      heading: heading ?? this.heading,
      title: title ?? this.title,
      lineHeightTitle: lineHeightTitle ?? this.lineHeightTitle,
      labelLetterSpacing: labelLetterSpacing ?? this.labelLetterSpacing,
      inlineCodeScale: inlineCodeScale ?? this.inlineCodeScale,
    );
  }

  static MaunaTypeScale lerp(MaunaTypeScale a, MaunaTypeScale b, double t) {
    return MaunaTypeScale(
      caption: lerpDouble(a.caption, b.caption, t)!,
      ui: lerpDouble(a.ui, b.ui, t)!,
      doc: lerpDouble(a.doc, b.doc, t)!,
      heading: lerpDouble(a.heading, b.heading, t)!,
      title: lerpDouble(a.title, b.title, t)!,
      lineHeightTitle: lerpDouble(a.lineHeightTitle, b.lineHeightTitle, t)!,
      labelLetterSpacing: lerpDouble(
        a.labelLetterSpacing,
        b.labelLetterSpacing,
        t,
      )!,
      inlineCodeScale: lerpDouble(a.inlineCodeScale, b.inlineCodeScale, t)!,
    );
  }
}

extension MaunaTextStyles on MaunaThemeData {
  TextStyle get captionStyle => TextStyle(
    inherit: false,
    fontFamily: fontUi,
    fontFamilyFallback: MaunaFonts.uiFallback,
    fontSize: typeScale.caption,
    height: lineHeightUi,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  TextStyle get labelStyle => TextStyle(
    inherit: false,
    fontFamily: fontUi,
    fontFamilyFallback: MaunaFonts.uiFallback,
    fontSize: typeScale.caption,
    height: lineHeightUi,
    fontWeight: FontWeight.w600,
    letterSpacing: typeScale.labelLetterSpacing,
    color: textSecondary,
  );

  TextStyle get uiStyle => TextStyle(
    inherit: false,
    fontFamily: fontUi,
    fontFamilyFallback: MaunaFonts.uiFallback,
    fontSize: typeScale.ui,
    height: lineHeightUi,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  TextStyle get docStyle => TextStyle(
    inherit: false,
    fontFamily: fontDoc,
    fontFamilyFallback: MaunaFonts.docFallback,
    fontSize: typeScale.doc,
    height: lineHeightDoc,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  TextStyle get headingStyle => TextStyle(
    inherit: false,
    fontFamily: fontUi,
    fontFamilyFallback: MaunaFonts.uiFallback,
    fontSize: typeScale.heading,
    height: lineHeightUi,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  TextStyle get titleStyle => TextStyle(
    inherit: false,
    fontFamily: fontUi,
    fontFamilyFallback: MaunaFonts.uiFallback,
    fontSize: typeScale.title,
    height: typeScale.lineHeightTitle,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
}
