import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';

class MaunaSidebar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final String? title = this.title;
    return ClipRect(
      child: AnimatedAlign(
        alignment: Alignment.centerRight,
        widthFactor: collapsed ? 0 : 1,
        duration: theme.motion.base,
        curve: MaunaMotion.baseCurve,
        child: ExcludeFocus(
          excluding: collapsed,
          child: Opacity(
            opacity: dimmed ? theme.metrics.dimmedChromeOpacity : 1,
            child: Container(
              width: width ?? theme.metrics.sidebarWidth,
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
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        vertical: title == null
                            ? theme.spacing.sm
                            : theme.spacing.xs,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: theme.metrics.listItemGap),
                      itemBuilder: (BuildContext context, int index) {
                        return _SidebarItem(
                          title: items[index],
                          selected: index == selectedIndex,
                          onTap: () => onSelected(index),
                        );
                      },
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
