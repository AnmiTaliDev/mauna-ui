import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_popup.dart';

class MaunaMenu extends StatelessWidget {
  const MaunaMenu({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return MaunaPopup(
      child: Padding(
        padding: EdgeInsets.all(theme.metrics.menuInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class MaunaMenuItem extends StatelessWidget {
  const MaunaMenuItem({
    super.key,
    required this.label,
    required this.highlighted,
    this.shortcut,
    this.onTap,
    this.onHover,
    this.onExit,
  });

  final String label;

  final bool highlighted;

  final String? shortcut;

  final VoidCallback? onTap;

  final VoidCallback? onHover;

  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final Color foreground = highlighted
        ? theme.textOnAccent
        : theme.textPrimary;
    return Semantics(
      button: true,
      selected: highlighted,
      child: MouseRegion(
        onHover: onHover == null ? null : (_) => onHover!(),
        onExit: onExit == null ? null : (_) => onExit!(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: theme.metrics.rowHeight),
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.sm,
              vertical: theme.metrics.listItemPaddingY,
            ),
            decoration: BoxDecoration(
              color: highlighted ? theme.accentFill : null,
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            child: Row(
              spacing: theme.spacing.xl,
              children: <Widget>[
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.uiStyle.copyWith(color: foreground),
                  ),
                ),
                if (shortcut case final String keys)
                  Text(
                    keys,
                    style: theme.uiStyle.copyWith(
                      color: highlighted
                          ? theme.textOnAccent
                          : theme.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MaunaMenuSeparator extends StatelessWidget {
  const MaunaMenuSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.metrics.menuInset,
      ),
      child: Container(height: theme.metrics.borderWidth, color: theme.line),
    );
  }
}
