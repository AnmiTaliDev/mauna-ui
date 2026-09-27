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
    this.collapsed = false,
    this.dimmed = false,
  });

  final List<String> items;

  final int? selectedIndex;

  final ValueChanged<int> onSelected;

  final bool collapsed;

  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
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
              width: theme.metrics.sidebarWidth,
              decoration: BoxDecoration(
                color: theme.bgChrome,
                border: Border(
                  right: BorderSide(
                    color: theme.line,
                    width: theme.metrics.borderWidth,
                  ),
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: theme.spacing.sm),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _SidebarItem(
                    title: items[index],
                    selected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  );
                },
              ),
            ),
          ),
        ),
      ),
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: selected ? theme.bgCanvas : null,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.lg,
              vertical: theme.spacing.sm,
            ),
            child: Text(
              title,
              style: theme.uiStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
