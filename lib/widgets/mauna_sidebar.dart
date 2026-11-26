import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';

class MaunaSidebar extends StatefulWidget {
  const MaunaSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.title,
    this.width,
    this.collapsed = false,
    this.dimmed = false,
  });

  final List<String> items;

  final int? selectedIndex;

  final ValueChanged<int> onSelected;

  final String? title;

  final double? width;

  final bool collapsed;

  final bool dimmed;

  @override
  State<MaunaSidebar> createState() => _MaunaSidebarState();
}

class _MaunaSidebarState extends State<MaunaSidebar> {
  final GlobalKey _selectedItem = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scheduleReveal();
  }

  @override
  void didUpdateWidget(MaunaSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scheduleReveal();
    }
  }

  void _scheduleReveal() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final BuildContext? item = _selectedItem.currentContext;
      if (item == null) {
        return;
      }
      for (final ScrollPositionAlignmentPolicy policy
          in <ScrollPositionAlignmentPolicy>[
            ScrollPositionAlignmentPolicy.keepVisibleAtStart,
            ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          ]) {
        Scrollable.ensureVisible(item, alignmentPolicy: policy);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final String? title = widget.title;
    return ClipRect(
      child: AnimatedAlign(
        alignment: Alignment.centerRight,
        widthFactor: widget.collapsed ? 0 : 1,
        duration: theme.motion.base,
        curve: MaunaMotion.baseCurve,
        child: ExcludeFocus(
          excluding: widget.collapsed,
          child: Opacity(
            opacity: widget.dimmed ? theme.metrics.dimmedChromeOpacity : 1,
            child: Container(
              width: widget.width ?? theme.metrics.sidebarWidth,
              decoration: BoxDecoration(
                color: theme.bgChrome,
                border: Border(
                  right: BorderSide(
                    color: theme.line,
                    width: theme.metrics.borderWidth,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (title != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        theme.spacing.md,
                        theme.spacing.md,
                        theme.spacing.md,
                        theme.spacing.xs,
                      ),
                      child: Text(
                        title.toUpperCase(),
                        style: theme.labelStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: title == null
                            ? theme.spacing.sm
                            : theme.spacing.xs,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: theme.metrics.listItemGap,
                        children: <Widget>[
                          for (int i = 0; i < widget.items.length; i++)
                            KeyedSubtree(
                              key: i == widget.selectedIndex
                                  ? _selectedItem
                                  : null,
                              child: _SidebarItem(
                                title: widget.items[i],
                                selected: i == widget.selectedIndex,
                                onTap: () => widget.onSelected(i),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) {
    setState(() => _hovered = value);
  }

  void _setFocused(bool value) {
    setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool strong = widget.selected || _hovered || _focused;
    final TextStyle style = theme.uiStyle.copyWith(
      color: strong ? theme.textPrimary : theme.textSecondary,
      fontWeight: widget.selected ? FontWeight.w500 : FontWeight.w400,
    );
    return Semantics(
      button: true,
      selected: widget.selected,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: _setHovered,
        onShowFocusHighlight: _setFocused,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) => widget.onTap(),
          ),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            color: widget.selected ? theme.bgCanvas : null,
            foregroundDecoration: _focused
                ? BoxDecoration(
                    border: Border.all(
                      color: theme.textSecondary,
                      width: theme.metrics.focusRingWidth,
                    ),
                  )
                : null,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.metrics.listItemPaddingY,
            ),
            child: AnimatedDefaultTextStyle(
              style: style,
              duration: theme.motion.fast,
              curve: MaunaMotion.fastCurve,
              child: Text(widget.title),
            ),
          ),
        ),
      ),
    );
  }
}
