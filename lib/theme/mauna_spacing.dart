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
    required this.toolbarButtonSize,
    required this.restoreButtonSize,
    required this.statusBarHeight,
    required this.sidebarWidth,
    required this.listItemPaddingY,
    required this.listItemGap,
    required this.documentColumnWidth,
    required this.borderWidth,
    required this.cursorWidth,
    required this.iconSize,
    required this.smallIconSize,
    required this.chipIconSize,
    required this.iconStrokeWidth,
    required this.focusRingWidth,
    required this.popupShadowBlur,
    required this.popupShadowOffsetY,
    required this.modalBarrierOpacity,
    required this.dimmedChromeOpacity,
    required this.separatorOpacity,
    required this.paletteWidth,
    required this.paletteMaxHeight,
    required this.dialogWidth,
    required this.dialogEnterScale,
  });

  static const MaunaMetrics standard = MaunaMetrics(
    toolbarHeight: 40,
    toolbarButtonSize: 28,
    restoreButtonSize: 24,
    statusBarHeight: 28,
    sidebarWidth: 200,
    listItemPaddingY: 6,
    listItemGap: 2,
    documentColumnWidth: 620,
    borderWidth: 0.5,
    cursorWidth: 2,
    iconSize: 18,
    smallIconSize: 14,
    chipIconSize: 16,
    iconStrokeWidth: 1.5,
    focusRingWidth: 1,
    popupShadowBlur: 8,
    popupShadowOffsetY: 2,
    modalBarrierOpacity: 0.4,
    dimmedChromeOpacity: 0.5,
    separatorOpacity: 0.4,
    paletteWidth: 480,
    paletteMaxHeight: 320,
    dialogWidth: 580,
    dialogEnterScale: 0.97,
  );

  final double toolbarHeight;

  final double toolbarButtonSize;

  final double restoreButtonSize;

  final double statusBarHeight;

  final double sidebarWidth;

  final double listItemPaddingY;

  final double listItemGap;

  final double documentColumnWidth;

  final double borderWidth;

  final double cursorWidth;

  final double iconSize;

  final double smallIconSize;

  final double chipIconSize;

  final double iconStrokeWidth;

  final double focusRingWidth;

  final double popupShadowBlur;

  final double popupShadowOffsetY;

  final double modalBarrierOpacity;

  final double dimmedChromeOpacity;

  final double separatorOpacity;

  final double paletteWidth;

  final double paletteMaxHeight;

  final double dialogWidth;

  final double dialogEnterScale;

  factory MaunaMetrics.fromJson(Map<String, Object?> json) {
    double read(String key) => (json[key]! as num).toDouble();
    return MaunaMetrics(
      toolbarHeight: read('toolbar_height'),
      toolbarButtonSize: read('toolbar_button_size'),
      restoreButtonSize: read('restore_button_size'),
      statusBarHeight: read('status_bar_height'),
      sidebarWidth: read('sidebar_width'),
      listItemPaddingY: read('list_item_padding_y'),
      listItemGap: read('list_item_gap'),
      documentColumnWidth: read('document_column_width'),
      borderWidth: read('border_width'),
      cursorWidth: read('cursor_width'),
      iconSize: read('icon_size'),
      smallIconSize: read('small_icon_size'),
      chipIconSize: read('chip_icon_size'),
      iconStrokeWidth: read('icon_stroke_width'),
      focusRingWidth: read('focus_ring_width'),
      popupShadowBlur: read('popup_shadow_blur'),
      popupShadowOffsetY: read('popup_shadow_offset_y'),
      modalBarrierOpacity: read('modal_barrier_opacity'),
      dimmedChromeOpacity: read('dimmed_chrome_opacity'),
      separatorOpacity: read('separator_opacity'),
      paletteWidth: read('palette_width'),
      paletteMaxHeight: read('palette_max_height'),
      dialogWidth: read('dialog_width'),
      dialogEnterScale: read('dialog_enter_scale'),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'toolbar_height': toolbarHeight,
      'toolbar_button_size': toolbarButtonSize,
      'restore_button_size': restoreButtonSize,
      'status_bar_height': statusBarHeight,
      'sidebar_width': sidebarWidth,
      'list_item_padding_y': listItemPaddingY,
      'list_item_gap': listItemGap,
      'document_column_width': documentColumnWidth,
      'border_width': borderWidth,
      'cursor_width': cursorWidth,
      'icon_size': iconSize,
      'small_icon_size': smallIconSize,
      'chip_icon_size': chipIconSize,
      'icon_stroke_width': iconStrokeWidth,
      'focus_ring_width': focusRingWidth,
      'popup_shadow_blur': popupShadowBlur,
      'popup_shadow_offset_y': popupShadowOffsetY,
      'modal_barrier_opacity': modalBarrierOpacity,
      'dimmed_chrome_opacity': dimmedChromeOpacity,
      'separator_opacity': separatorOpacity,
      'palette_width': paletteWidth,
      'palette_max_height': paletteMaxHeight,
      'dialog_width': dialogWidth,
      'dialog_enter_scale': dialogEnterScale,
    };
  }

  static MaunaMetrics lerp(MaunaMetrics a, MaunaMetrics b, double t) {
    return MaunaMetrics(
      toolbarHeight: lerpDouble(a.toolbarHeight, b.toolbarHeight, t)!,
      toolbarButtonSize: lerpDouble(
        a.toolbarButtonSize,
        b.toolbarButtonSize,
        t,
      )!,
      restoreButtonSize: lerpDouble(
        a.restoreButtonSize,
        b.restoreButtonSize,
        t,
      )!,
      statusBarHeight: lerpDouble(a.statusBarHeight, b.statusBarHeight, t)!,
      sidebarWidth: lerpDouble(a.sidebarWidth, b.sidebarWidth, t)!,
      listItemPaddingY: lerpDouble(a.listItemPaddingY, b.listItemPaddingY, t)!,
      listItemGap: lerpDouble(a.listItemGap, b.listItemGap, t)!,
      documentColumnWidth: lerpDouble(
        a.documentColumnWidth,
        b.documentColumnWidth,
        t,
      )!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      cursorWidth: lerpDouble(a.cursorWidth, b.cursorWidth, t)!,
      iconSize: lerpDouble(a.iconSize, b.iconSize, t)!,
      smallIconSize: lerpDouble(a.smallIconSize, b.smallIconSize, t)!,
      chipIconSize: lerpDouble(a.chipIconSize, b.chipIconSize, t)!,
      iconStrokeWidth: lerpDouble(a.iconStrokeWidth, b.iconStrokeWidth, t)!,
      focusRingWidth: lerpDouble(a.focusRingWidth, b.focusRingWidth, t)!,
      popupShadowBlur: lerpDouble(a.popupShadowBlur, b.popupShadowBlur, t)!,
      popupShadowOffsetY: lerpDouble(
        a.popupShadowOffsetY,
        b.popupShadowOffsetY,
        t,
      )!,
      modalBarrierOpacity: lerpDouble(
        a.modalBarrierOpacity,
        b.modalBarrierOpacity,
        t,
      )!,
      dimmedChromeOpacity: lerpDouble(
        a.dimmedChromeOpacity,
        b.dimmedChromeOpacity,
        t,
      )!,
      separatorOpacity: lerpDouble(a.separatorOpacity, b.separatorOpacity, t)!,
      paletteWidth: lerpDouble(a.paletteWidth, b.paletteWidth, t)!,
      paletteMaxHeight: lerpDouble(a.paletteMaxHeight, b.paletteMaxHeight, t)!,
      dialogWidth: lerpDouble(a.dialogWidth, b.dialogWidth, t)!,
      dialogEnterScale: lerpDouble(a.dialogEnterScale, b.dialogEnterScale, t)!,
    );
  }
}
