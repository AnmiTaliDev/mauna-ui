import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';

class MaunaFocusRing extends StatelessWidget {
  const MaunaFocusRing({
    super.key,
    required this.visible,
    required this.radius,
    required this.child,
  });

  final bool visible;

  final double radius;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: visible
            ? Border.all(
                color: theme.focusRingColor,
                width: theme.metrics.focusRingWidth,
                strokeAlign: BorderSide.strokeAlignOutside,
              )
            : null,
      ),
      child: child,
    );
  }
}
