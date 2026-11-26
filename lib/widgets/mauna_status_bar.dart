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
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
        color: theme.bgCanvas,
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
    return Row(
      spacing: theme.spacing.lg,
      children: <Widget>[
        for (final String item in items) Text(item, style: theme.captionStyle),
      ],
    );
  }
}
