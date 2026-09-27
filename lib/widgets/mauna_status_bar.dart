import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';

class MaunaStatusBar extends StatelessWidget {
  const MaunaStatusBar({
    super.key,
    this.leading = const <String>[],
    this.trailing = const <String>[],
    this.dimmed = false,
  });

  final List<String> leading;

  final List<String> trailing;

  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Opacity(
      opacity: dimmed ? theme.metrics.dimmedChromeOpacity : 1,
      child: Container(
        height: theme.metrics.statusBarHeight,
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
        decoration: BoxDecoration(
          color: theme.bgChrome,
          border: Border(
            top: BorderSide(
              color: theme.line,
              width: theme.metrics.borderWidth,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            _StatusGroup(items: leading),
            const Spacer(),
            _StatusGroup(items: trailing),
          ],
        ),
      ),
    );
  }
}

class _StatusGroup extends StatelessWidget {
  const _StatusGroup({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final TextStyle style = theme.captionStyle;
    final TextStyle separatorStyle = style.copyWith(
      color: theme.textSecondary.withValues(
        alpha: theme.metrics.separatorOpacity,
      ),
    );
    return Row(
      spacing: theme.spacing.xs,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          if (i > 0) ExcludeSemantics(child: Text('|', style: separatorStyle)),
          Text(items[i], style: style),
        ],
      ],
    );
  }
}
