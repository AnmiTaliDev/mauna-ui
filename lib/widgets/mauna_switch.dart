import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import 'mauna_focus_ring.dart';
import 'mauna_pressable.dart';

class MaunaSwitch extends StatelessWidget {
  const MaunaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;

  final ValueChanged<bool> onChanged;

  final String label;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final double height = theme.metrics.switchHeight;
    const double inset = 2;
    return Semantics(
      toggled: value,
      label: label,
      child: MaunaPressable(
        onPressed: () => onChanged(!value),
        builder: (BuildContext context, bool hovered, bool focused) {
          return MaunaFocusRing(
            visible: focused,
            radius: height / 2,
            child: AnimatedContainer(
              duration: theme.motion.fast,
              curve: MaunaMotion.fastCurve,
              width: theme.metrics.switchWidth,
              height: height,
              padding: const EdgeInsets.all(inset),
              decoration: BoxDecoration(
                color: value
                    ? theme.accentFill
                    : Color.alphaBlend(theme.fill, theme.line),
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: AnimatedAlign(
                duration: theme.motion.fast,
                curve: MaunaMotion.fastCurve,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: height - inset * 2,
                  height: height - inset * 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    shape: BoxShape.circle,
                    boxShadow: theme.controlShadows,
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
