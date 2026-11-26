import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_focus_ring.dart';
import 'mauna_popup.dart';
import 'mauna_pressable.dart';

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
    this.onReorder,
    this.canReorder,
  });

  final List<String> items;

  final int? selectedIndex;

  final ValueChanged<int> onSelected;

  final String? title;

  final double? width;

  final bool collapsed;

  final bool dimmed;

  final void Function(int from, int to)? onReorder;

  final bool Function(int from, int to)? canReorder;

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

  bool _accepts(int from, int to) {
    return from != to && (widget.canReorder?.call(from, to) ?? true);
  }

  Widget _item(int index) {
    final Widget item = _SidebarItem(
      title: widget.items[index],
      selected: index == widget.selectedIndex,
      onTap: () => widget.onSelected(index),
    );
    final void Function(int from, int to)? onReorder = widget.onReorder;
    if (onReorder == null) {
      return item;
    }
    return _ReorderableItem(
      index: index,
      title: widget.items[index],
      width: widget.width,
      accepts: (int from) => _accepts(from, index),
      onAccept: (int from) => onReorder(from, index),
      child: item,
    );
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
                        theme.spacing.lg,
                        theme.spacing.md,
                        theme.spacing.md,
                        theme.spacing.xs,
                      ),
                      child: Text(
                        title,
                        style: theme.labelStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.sm,
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
                              child: _item(i),
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

class _ReorderableItem extends StatelessWidget {
  const _ReorderableItem({
    required this.index,
    required this.title,
    required this.width,
    required this.accepts,
    required this.onAccept,
    required this.child,
  });

  final int index;
  final String title;
  final double? width;
  final bool Function(int from) accepts;
  final ValueChanged<int> onAccept;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return DragTarget<int>(
      onWillAcceptWithDetails: (DragTargetDetails<int> details) =>
          accepts(details.data),
      onAcceptWithDetails: (DragTargetDetails<int> details) =>
          onAccept(details.data),
      builder:
          (
            BuildContext context,
            List<int?> candidates,
            List<dynamic> rejected,
          ) {
            final int? from = candidates.firstOrNull;
            final BorderSide mark = BorderSide(
              color: theme.accent,
              width: theme.metrics.cursorWidth,
            );
            return Draggable<int>(
              data: index,
              maxSimultaneousDrags: 1,
              dragAnchorStrategy: pointerDragAnchorStrategy,
              feedback: SizedBox(
                width: width ?? theme.metrics.sidebarWidth,
                child: MaunaPopup(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.md,
                      vertical: theme.metrics.listItemPaddingY,
                    ),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.uiStyle,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: theme.metrics.dimmedChromeOpacity,
                child: child,
              ),
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  border: from == null
                      ? null
                      : Border(
                          top: from > index ? mark : BorderSide.none,
                          bottom: from < index ? mark : BorderSide.none,
                        ),
                ),
                child: child,
              ),
            );
          },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: MaunaPressable(
        onPressed: onTap,
        builder: (BuildContext context, bool hovered, bool focused) {
          return MaunaFocusRing(
            visible: focused,
            radius: theme.radiusSm,
            child: Container(
              constraints: BoxConstraints(minHeight: theme.metrics.rowHeight),
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.sm,
                vertical: theme.metrics.listItemPaddingY,
              ),
              decoration: BoxDecoration(
                color: selected ? theme.fill : null,
                borderRadius: BorderRadius.circular(theme.radiusSm),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.uiStyle.copyWith(
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
