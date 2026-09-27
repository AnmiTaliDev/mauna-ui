import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';

class MaunaStatusBar extends StatelessWidget {
  const MaunaStatusBar({super.key, required this.items, this.dimmed = false});

  final List<String> items;

  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Opacity(
      opacity: dimmed ? theme.metrics.dimmedChromeOpacity : 1,
      child: Container(
        height: theme.metrics.statusBarHeight,
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
        decoration: BoxDecoration(
          color: theme.bgCanvas,
          border: Border(
            top: BorderSide(
              color: theme.line,
              width: theme.metrics.borderWidth,
            ),
          ),
        ),
        child: Row(
          spacing: theme.spacing.lg,
          children: <Widget>[
            for (final String item in items)
              Text(item, style: theme.captionStyle),
          ],
        ),
      ),
    );
  }
}
