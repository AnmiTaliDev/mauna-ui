import 'dart:ui' show lerpDouble;

class MaunaSpacing {
  const MaunaSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  static const MaunaSpacing standard = MaunaSpacing(
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
    xxl: 32,
    xxxl: 48,
  );

  final double xs;

  final double sm;

  final double md;

  final double lg;

  final double xl;

  final double xxl;

  final double xxxl;

  factory MaunaSpacing.fromJson(Map<String, Object?> json) {
    return MaunaSpacing(
      xs: (json['xs']! as num).toDouble(),
      sm: (json['sm']! as num).toDouble(),
      md: (json['md']! as num).toDouble(),
      lg: (json['lg']! as num).toDouble(),
      xl: (json['xl']! as num).toDouble(),
      xxl: (json['2xl']! as num).toDouble(),
      xxxl: (json['3xl']! as num).toDouble(),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'xs': xs,
      'sm': sm,
      'md': md,
      'lg': lg,
      'xl': xl,
      '2xl': xxl,
      '3xl': xxxl,
    };
  }

  static MaunaSpacing lerp(MaunaSpacing a, MaunaSpacing b, double t) {
    return MaunaSpacing(
      xs: lerpDouble(a.xs, b.xs, t)!,
      sm: lerpDouble(a.sm, b.sm, t)!,
      md: lerpDouble(a.md, b.md, t)!,
      lg: lerpDouble(a.lg, b.lg, t)!,
      xl: lerpDouble(a.xl, b.xl, t)!,
      xxl: lerpDouble(a.xxl, b.xxl, t)!,
      xxxl: lerpDouble(a.xxxl, b.xxxl, t)!,
    );
  }
}

class MaunaMetrics {
  const MaunaMetrics({
    required this.toolbarHeight,
    required this.statusBarHeight,
    required this.sidebarWidth,
    required this.documentColumnWidth,
    required this.borderWidth,
    required this.cursorWidth,
    required this.iconSize,
    required this.popupShadowBlur,
    required this.popupShadowOffsetY,
    required this.dimmedChromeOpacity,
    required this.selectionOpacity,
    required this.paletteWidth,
    required this.paletteMaxHeight,
  });

  static const MaunaMetrics standard = MaunaMetrics(
    toolbarHeight: 40,
    statusBarHeight: 28,
    sidebarWidth: 184,
    documentColumnWidth: 620,
    borderWidth: 0.5,
    cursorWidth: 2,
    iconSize: 18,
    popupShadowBlur: 8,
    popupShadowOffsetY: 2,
    dimmedChromeOpacity: 0.5,
    selectionOpacity: 0.25,
    paletteWidth: 480,
    paletteMaxHeight: 320,
  );

  final double toolbarHeight;

  final double statusBarHeight;

  final double sidebarWidth;

  final double documentColumnWidth;

  final double borderWidth;

  final double cursorWidth;

  final double iconSize;

  final double popupShadowBlur;

  final double popupShadowOffsetY;

  final double dimmedChromeOpacity;

  final double selectionOpacity;

  final double paletteWidth;

  final double paletteMaxHeight;

  factory MaunaMetrics.fromJson(Map<String, Object?> json) {
    double read(String key) => (json[key]! as num).toDouble();
    return MaunaMetrics(
      toolbarHeight: read('toolbar_height'),
      statusBarHeight: read('status_bar_height'),
      sidebarWidth: read('sidebar_width'),
      documentColumnWidth: read('document_column_width'),
      borderWidth: read('border_width'),
      cursorWidth: read('cursor_width'),
      iconSize: read('icon_size'),
      popupShadowBlur: read('popup_shadow_blur'),
      popupShadowOffsetY: read('popup_shadow_offset_y'),
      dimmedChromeOpacity: read('dimmed_chrome_opacity'),
      selectionOpacity: read('selection_opacity'),
      paletteWidth: read('palette_width'),
      paletteMaxHeight: read('palette_max_height'),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'toolbar_height': toolbarHeight,
      'status_bar_height': statusBarHeight,
      'sidebar_width': sidebarWidth,
      'document_column_width': documentColumnWidth,
      'border_width': borderWidth,
      'cursor_width': cursorWidth,
      'icon_size': iconSize,
      'popup_shadow_blur': popupShadowBlur,
      'popup_shadow_offset_y': popupShadowOffsetY,
      'dimmed_chrome_opacity': dimmedChromeOpacity,
      'selection_opacity': selectionOpacity,
      'palette_width': paletteWidth,
      'palette_max_height': paletteMaxHeight,
    };
  }

  static MaunaMetrics lerp(MaunaMetrics a, MaunaMetrics b, double t) {
    return MaunaMetrics(
      toolbarHeight: lerpDouble(a.toolbarHeight, b.toolbarHeight, t)!,
      statusBarHeight: lerpDouble(a.statusBarHeight, b.statusBarHeight, t)!,
      sidebarWidth: lerpDouble(a.sidebarWidth, b.sidebarWidth, t)!,
      documentColumnWidth: lerpDouble(
        a.documentColumnWidth,
        b.documentColumnWidth,
        t,
      )!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      cursorWidth: lerpDouble(a.cursorWidth, b.cursorWidth, t)!,
      iconSize: lerpDouble(a.iconSize, b.iconSize, t)!,
      popupShadowBlur: lerpDouble(a.popupShadowBlur, b.popupShadowBlur, t)!,
      popupShadowOffsetY: lerpDouble(
        a.popupShadowOffsetY,
        b.popupShadowOffsetY,
        t,
      )!,
      dimmedChromeOpacity: lerpDouble(
        a.dimmedChromeOpacity,
        b.dimmedChromeOpacity,
        t,
      )!,
      selectionOpacity: lerpDouble(a.selectionOpacity, b.selectionOpacity, t)!,
      paletteWidth: lerpDouble(a.paletteWidth, b.paletteWidth, t)!,
      paletteMaxHeight: lerpDouble(a.paletteMaxHeight, b.paletteMaxHeight, t)!,
    );
  }
}
