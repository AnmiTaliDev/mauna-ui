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
    required this.rowHeight,
    required this.controlHeight,
    required this.listItemPaddingY,
    required this.listItemGap,
    required this.menuInset,
    required this.documentColumnWidth,
    required this.borderWidth,
    required this.cursorWidth,
    required this.iconSize,
    required this.smallIconSize,
    required this.iconStrokeWidth,
    required this.focusRingWidth,
    required this.focusRingOpacity,
    required this.popupShadowBlur,
    required this.popupShadowOffsetY,
    required this.modalBarrierOpacity,
    required this.dimmedChromeOpacity,
    required this.paletteWidth,
    required this.paletteMaxHeight,
    required this.menuWidth,
    required this.dialogWidth,
    required this.dialogEnterScale,
    required this.switchWidth,
    required this.switchHeight,
  });

  static const MaunaMetrics standard = MaunaMetrics(
    toolbarHeight: 44,
    toolbarButtonSize: 28,
    restoreButtonSize: 24,
    statusBarHeight: 26,
    sidebarWidth: 220,
    rowHeight: 26,
    controlHeight: 28,
    listItemPaddingY: 4,
    listItemGap: 1,
    menuInset: 5,
    documentColumnWidth: 620,
    borderWidth: 1,
    cursorWidth: 2,
    iconSize: 16,
    smallIconSize: 12,
    iconStrokeWidth: 1.4,
    focusRingWidth: 3,
    focusRingOpacity: 0.5,
    popupShadowBlur: 28,
    popupShadowOffsetY: 10,
    modalBarrierOpacity: 0.22,
    dimmedChromeOpacity: 0.5,
    paletteWidth: 560,
    paletteMaxHeight: 348,
    menuWidth: 220,
    dialogWidth: 640,
    dialogEnterScale: 0.97,
    switchWidth: 36,
    switchHeight: 20,
  );

  final double toolbarHeight;

  final double toolbarButtonSize;

  final double restoreButtonSize;

  final double statusBarHeight;

  final double sidebarWidth;

  final double rowHeight;

  final double controlHeight;

  final double listItemPaddingY;

  final double listItemGap;

  final double menuInset;

  final double documentColumnWidth;

  final double borderWidth;

  final double cursorWidth;

  final double iconSize;

  final double smallIconSize;

  final double iconStrokeWidth;

  final double focusRingWidth;

  final double focusRingOpacity;

  final double popupShadowBlur;

  final double popupShadowOffsetY;

  final double modalBarrierOpacity;

  final double dimmedChromeOpacity;

  final double paletteWidth;

  final double paletteMaxHeight;

  final double menuWidth;

  final double dialogWidth;

  final double dialogEnterScale;

  final double switchWidth;

  final double switchHeight;

  factory MaunaMetrics.fromJson(Map<String, Object?> json) {
    double read(String key) => (json[key]! as num).toDouble();
    return MaunaMetrics(
      toolbarHeight: read('toolbar_height'),
      toolbarButtonSize: read('toolbar_button_size'),
      restoreButtonSize: read('restore_button_size'),
      statusBarHeight: read('status_bar_height'),
      sidebarWidth: read('sidebar_width'),
      rowHeight: read('row_height'),
      controlHeight: read('control_height'),
      listItemPaddingY: read('list_item_padding_y'),
      listItemGap: read('list_item_gap'),
      menuInset: read('menu_inset'),
      documentColumnWidth: read('document_column_width'),
      borderWidth: read('border_width'),
      cursorWidth: read('cursor_width'),
      iconSize: read('icon_size'),
      smallIconSize: read('small_icon_size'),
      iconStrokeWidth: read('icon_stroke_width'),
      focusRingWidth: read('focus_ring_width'),
      focusRingOpacity: read('focus_ring_opacity'),
      popupShadowBlur: read('popup_shadow_blur'),
      popupShadowOffsetY: read('popup_shadow_offset_y'),
      modalBarrierOpacity: read('modal_barrier_opacity'),
      dimmedChromeOpacity: read('dimmed_chrome_opacity'),
      paletteWidth: read('palette_width'),
      paletteMaxHeight: read('palette_max_height'),
      menuWidth: read('menu_width'),
      dialogWidth: read('dialog_width'),
      dialogEnterScale: read('dialog_enter_scale'),
      switchWidth: read('switch_width'),
      switchHeight: read('switch_height'),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'toolbar_height': toolbarHeight,
      'toolbar_button_size': toolbarButtonSize,
      'restore_button_size': restoreButtonSize,
      'status_bar_height': statusBarHeight,
      'sidebar_width': sidebarWidth,
      'row_height': rowHeight,
      'control_height': controlHeight,
      'list_item_padding_y': listItemPaddingY,
      'list_item_gap': listItemGap,
      'menu_inset': menuInset,
      'document_column_width': documentColumnWidth,
      'border_width': borderWidth,
      'cursor_width': cursorWidth,
      'icon_size': iconSize,
      'small_icon_size': smallIconSize,
      'icon_stroke_width': iconStrokeWidth,
      'focus_ring_width': focusRingWidth,
      'focus_ring_opacity': focusRingOpacity,
      'popup_shadow_blur': popupShadowBlur,
      'popup_shadow_offset_y': popupShadowOffsetY,
      'modal_barrier_opacity': modalBarrierOpacity,
      'dimmed_chrome_opacity': dimmedChromeOpacity,
      'palette_width': paletteWidth,
      'palette_max_height': paletteMaxHeight,
      'menu_width': menuWidth,
      'dialog_width': dialogWidth,
      'dialog_enter_scale': dialogEnterScale,
      'switch_width': switchWidth,
      'switch_height': switchHeight,
    };
  }

  MaunaMetrics copyWith({
    double? toolbarHeight,
    double? toolbarButtonSize,
    double? restoreButtonSize,
    double? statusBarHeight,
    double? sidebarWidth,
    double? rowHeight,
    double? controlHeight,
    double? listItemPaddingY,
    double? listItemGap,
    double? menuInset,
    double? documentColumnWidth,
    double? borderWidth,
    double? cursorWidth,
    double? iconSize,
    double? smallIconSize,
    double? iconStrokeWidth,
    double? focusRingWidth,
    double? focusRingOpacity,
    double? popupShadowBlur,
    double? popupShadowOffsetY,
    double? modalBarrierOpacity,
    double? dimmedChromeOpacity,
    double? paletteWidth,
    double? paletteMaxHeight,
    double? menuWidth,
    double? dialogWidth,
    double? dialogEnterScale,
    double? switchWidth,
    double? switchHeight,
  }) {
    return MaunaMetrics(
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      toolbarButtonSize: toolbarButtonSize ?? this.toolbarButtonSize,
      restoreButtonSize: restoreButtonSize ?? this.restoreButtonSize,
      statusBarHeight: statusBarHeight ?? this.statusBarHeight,
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
      rowHeight: rowHeight ?? this.rowHeight,
      controlHeight: controlHeight ?? this.controlHeight,
      listItemPaddingY: listItemPaddingY ?? this.listItemPaddingY,
      listItemGap: listItemGap ?? this.listItemGap,
      menuInset: menuInset ?? this.menuInset,
      documentColumnWidth: documentColumnWidth ?? this.documentColumnWidth,
      borderWidth: borderWidth ?? this.borderWidth,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      iconSize: iconSize ?? this.iconSize,
      smallIconSize: smallIconSize ?? this.smallIconSize,
      iconStrokeWidth: iconStrokeWidth ?? this.iconStrokeWidth,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      focusRingOpacity: focusRingOpacity ?? this.focusRingOpacity,
      popupShadowBlur: popupShadowBlur ?? this.popupShadowBlur,
      popupShadowOffsetY: popupShadowOffsetY ?? this.popupShadowOffsetY,
      modalBarrierOpacity: modalBarrierOpacity ?? this.modalBarrierOpacity,
      dimmedChromeOpacity: dimmedChromeOpacity ?? this.dimmedChromeOpacity,
      paletteWidth: paletteWidth ?? this.paletteWidth,
      paletteMaxHeight: paletteMaxHeight ?? this.paletteMaxHeight,
      menuWidth: menuWidth ?? this.menuWidth,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      dialogEnterScale: dialogEnterScale ?? this.dialogEnterScale,
      switchWidth: switchWidth ?? this.switchWidth,
      switchHeight: switchHeight ?? this.switchHeight,
    );
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
      rowHeight: lerpDouble(a.rowHeight, b.rowHeight, t)!,
      controlHeight: lerpDouble(a.controlHeight, b.controlHeight, t)!,
      listItemPaddingY: lerpDouble(a.listItemPaddingY, b.listItemPaddingY, t)!,
      listItemGap: lerpDouble(a.listItemGap, b.listItemGap, t)!,
      menuInset: lerpDouble(a.menuInset, b.menuInset, t)!,
      documentColumnWidth: lerpDouble(
        a.documentColumnWidth,
        b.documentColumnWidth,
        t,
      )!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      cursorWidth: lerpDouble(a.cursorWidth, b.cursorWidth, t)!,
      iconSize: lerpDouble(a.iconSize, b.iconSize, t)!,
      smallIconSize: lerpDouble(a.smallIconSize, b.smallIconSize, t)!,
      iconStrokeWidth: lerpDouble(a.iconStrokeWidth, b.iconStrokeWidth, t)!,
      focusRingWidth: lerpDouble(a.focusRingWidth, b.focusRingWidth, t)!,
      focusRingOpacity: lerpDouble(a.focusRingOpacity, b.focusRingOpacity, t)!,
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
      paletteWidth: lerpDouble(a.paletteWidth, b.paletteWidth, t)!,
      paletteMaxHeight: lerpDouble(a.paletteMaxHeight, b.paletteMaxHeight, t)!,
      menuWidth: lerpDouble(a.menuWidth, b.menuWidth, t)!,
      dialogWidth: lerpDouble(a.dialogWidth, b.dialogWidth, t)!,
      dialogEnterScale: lerpDouble(a.dialogEnterScale, b.dialogEnterScale, t)!,
      switchWidth: lerpDouble(a.switchWidth, b.switchWidth, t)!,
      switchHeight: lerpDouble(a.switchHeight, b.switchHeight, t)!,
    );
  }
}
