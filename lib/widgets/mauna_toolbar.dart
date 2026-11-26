import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_focus_ring.dart';
import 'mauna_icon.dart';
import 'mauna_pressable.dart';

class MaunaToolbar extends StatelessWidget {
  const MaunaToolbar({
    super.key,
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    this.center,
    this.hidden = false,
    this.dimmed = false,
  });

  final List<Widget> leading;

  final List<Widget> trailing;

  final Widget? center;

  final bool hidden;

  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return ClipRect(
      child: AnimatedAlign(
        alignment: Alignment.bottomCenter,
        heightFactor: hidden ? 0 : 1,
        duration: theme.motion.slow,
        curve: MaunaMotion.slowCurve,
        child: AnimatedOpacity(
          opacity: hidden ? 0 : 1,
          duration: theme.motion.slow,
          curve: MaunaMotion.slowCurve,
          child: ExcludeFocus(
            excluding: hidden,
            child: Opacity(
              opacity: dimmed ? theme.metrics.dimmedChromeOpacity : 1,
              child: Container(
                height: theme.metrics.toolbarHeight,
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.sm),
                decoration: BoxDecoration(
                  color: theme.bgCanvas,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.line,
                      width: theme.metrics.borderWidth,
                    ),
                  ),
                ),
                child: Row(
                  spacing: theme.spacing.sm,
                  children: <Widget>[
                    Row(spacing: theme.metrics.listItemGap, children: leading),
                    Expanded(child: center ?? const SizedBox.shrink()),
                    Row(spacing: theme.metrics.listItemGap, children: trailing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MaunaToolbarButton extends StatelessWidget {
  const MaunaToolbarButton({
    super.key,
    this.icon,
    required this.label,
    this.onPressed,
    this.accent = false,
  });

  final Path? icon;

  final String label;

  final VoidCallback? onPressed;

  final bool accent;

  Color _foreground(MaunaThemeData theme, bool highlighted) {
    if (onPressed == null) {
      return theme.textSecondary.withValues(
        alpha: theme.metrics.dimmedChromeOpacity,
      );
    }
    if (accent) {
      return theme.accent;
    }
    return icon == null || highlighted
        ? theme.textPrimary
        : theme.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final double size = theme.metrics.toolbarButtonSize;
    final Path? glyph = icon;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      child: MaunaPressable(
        onPressed: onPressed,
        builder: (BuildContext context, bool hovered, bool focused) {
          final Color color = _foreground(theme, hovered || focused);
          return MaunaFocusRing(
            visible: focused,
            radius: theme.radiusSm,
            child: AnimatedContainer(
              duration: theme.motion.fast,
              curve: MaunaMotion.fastCurve,
              height: size,
              constraints: BoxConstraints(minWidth: size),
              padding: glyph == null
                  ? EdgeInsets.symmetric(horizontal: theme.spacing.sm)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: hovered || focused
                    ? theme.fill
                    : theme.fill.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(theme.radiusSm),
              ),
              child: Center(
                widthFactor: 1,
                child: glyph == null
                    ? Text(label, style: theme.uiStyle.copyWith(color: color))
                    : MaunaIcon(glyph, color: color),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MaunaToolbarRestoreButton extends StatelessWidget {
  const MaunaToolbarRestoreButton({
    super.key,
    required this.onPressed,
    this.label = 'Show toolbar',
  });

  final VoidCallback onPressed;

  final String label;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final double size = theme.metrics.restoreButtonSize;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: MaunaPressable(
        onPressed: onPressed,
        builder: (BuildContext context, bool hovered, bool focused) {
          return MaunaFocusRing(
            visible: focused,
            radius: theme.radiusSm,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.bgCard,
                border: Border.all(
                  color: theme.line,
                  width: theme.metrics.borderWidth,
                ),
                borderRadius: BorderRadius.circular(theme.radiusSm),
                boxShadow: theme.controlShadows,
              ),
              child: MaunaIcon(
                MaunaGlyphs.chevronDown(),
                color: hovered || focused
                    ? theme.textPrimary
                    : theme.textSecondary,
                size: theme.metrics.smallIconSize,
              ),
            ),
          );
        },
      ),
    );
  }
}
