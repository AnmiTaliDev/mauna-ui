import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_focus_ring.dart';
import 'mauna_pressable.dart';

class MaunaButton extends StatelessWidget {
  const MaunaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.prominent = false,
  });

  final String label;

  final VoidCallback? onPressed;

  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: MaunaPressable(
        onPressed: onPressed,
        builder: (BuildContext context, bool hovered, bool focused) {
          final Color background = prominent
              ? theme.accentFill
              : theme.bgControl;
          return Opacity(
            opacity: enabled ? 1 : theme.metrics.dimmedChromeOpacity,
            child: MaunaFocusRing(
              visible: focused,
              radius: theme.radiusSm,
              child: Container(
                height: theme.metrics.controlHeight,
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                decoration: BoxDecoration(
                  color: hovered
                      ? Color.alphaBlend(theme.fill, background)
                      : background,
                  borderRadius: BorderRadius.circular(theme.radiusSm),
                  border: prominent
                      ? null
                      : Border.all(
                          color: theme.line,
                          width: theme.metrics.borderWidth,
                        ),
                  boxShadow: theme.controlShadows,
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.uiStyle.copyWith(
                      color: prominent ? theme.textOnAccent : theme.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
