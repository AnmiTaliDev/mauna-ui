import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_focus_ring.dart';
import 'mauna_pressable.dart';

class MaunaSegmentedControl<T> extends StatelessWidget {
  const MaunaSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> segments;

  final T selected;

  final ValueChanged<T> onChanged;

  Widget _segment(MaunaThemeData theme, T value, String label) {
    final bool active = value == selected;
    return Semantics(
      button: true,
      selected: active,
      child: MaunaPressable(
        onPressed: () => onChanged(value),
        builder: (BuildContext context, bool hovered, bool focused) {
          return MaunaFocusRing(
            visible: focused,
            radius: theme.radiusSm - 1,
            child: AnimatedContainer(
              duration: theme.motion.fast,
              curve: MaunaMotion.fastCurve,
              height: theme.metrics.controlHeight - 4,
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
              decoration: BoxDecoration(
                color: active
                    ? theme.bgControl
                    : theme.bgControl.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(theme.radiusSm - 1),
                boxShadow: active ? theme.controlShadows : null,
              ),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.uiStyle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Container(
      height: theme.metrics.controlHeight,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.fill,
        borderRadius: BorderRadius.circular(theme.radiusSm + 1),
      ),
      child: Row(
        children: <Widget>[
          for (final MapEntry<T, String> entry in segments.entries)
            Expanded(child: _segment(theme, entry.key, entry.value)),
        ],
      ),
    );
  }
}
