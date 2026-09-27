import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_icon.dart';

class MaunaToolbar extends StatelessWidget {
  const MaunaToolbar({
    super.key,
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    this.hidden = false,
    this.dimmed = false,
  });

  final List<Widget> leading;

  final List<Widget> trailing;

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
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                decoration: BoxDecoration(
                  color: theme.bgChrome,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.line,
                      width: theme.metrics.borderWidth,
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Row(spacing: theme.spacing.xs, children: leading),
                    const Spacer(),
                    Row(spacing: theme.spacing.xs, children: trailing),
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

class MaunaToolbarButton extends StatefulWidget {
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

  @override
  State<MaunaToolbarButton> createState() => _MaunaToolbarButtonState();
}

class _MaunaToolbarButtonState extends State<MaunaToolbarButton> {
  bool _hovered = false;
  bool _focused = false;

  void _activate() {
    widget.onPressed?.call();
  }

  void _setHovered(bool value) {
    setState(() => _hovered = value);
  }

  void _setFocused(bool value) {
    setState(() => _focused = value);
  }

  Color _foreground(MaunaThemeData theme, bool enabled, bool highlighted) {
    if (!enabled) {
      return theme.textSecondary.withValues(
        alpha: theme.metrics.dimmedChromeOpacity,
      );
    }
    if (highlighted) {
      return theme.textPrimary;
    }
    return widget.accent ? theme.accent : theme.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool enabled = widget.onPressed != null;
    final bool highlighted = enabled && (_hovered || _focused);
    final double size = theme.metrics.toolbarButtonSize;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: _setHovered,
        onShowFocusHighlight: _setFocused,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) => _activate(),
          ),
        },
        child: GestureDetector(
          onTap: enabled ? _activate : null,
          child: AnimatedContainer(
            duration: theme.motion.fast,
            curve: MaunaMotion.fastCurve,
            height: size,
            constraints: BoxConstraints(minWidth: size),
            padding: widget.icon == null
                ? EdgeInsets.symmetric(horizontal: theme.spacing.sm)
                : EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted && widget.icon != null
                  ? theme.bgCanvas
                  : theme.bgCanvas.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: _foreground(theme, enabled, highlighted)),
              duration: theme.motion.fast,
              curve: MaunaMotion.fastCurve,
              builder: (BuildContext context, Color? color, Widget? child) {
                return widget.icon == null
                    ? Text(
                        widget.label,
                        style: theme.captionStyle.copyWith(color: color),
                      )
                    : MaunaIcon(widget.icon!, color: color!);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MaunaToolbarRestoreButton extends StatefulWidget {
  const MaunaToolbarRestoreButton({
    super.key,
    required this.onPressed,
    this.label = 'Show toolbar',
  });

  final VoidCallback onPressed;

  final String label;

  @override
  State<MaunaToolbarRestoreButton> createState() =>
      _MaunaToolbarRestoreButtonState();
}

class _MaunaToolbarRestoreButtonState extends State<MaunaToolbarRestoreButton> {
  bool _highlighted = false;

  void _setHighlighted(bool value) {
    setState(() => _highlighted = value);
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final double size = theme.metrics.restoreButtonSize;
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: _setHighlighted,
        onShowFocusHighlight: _setHighlighted,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) => widget.onPressed(),
          ),
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.bgChrome,
              border: Border.all(
                color: theme.line,
                width: theme.metrics.borderWidth,
              ),
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                end: _highlighted ? theme.textPrimary : theme.textSecondary,
              ),
              duration: theme.motion.fast,
              curve: MaunaMotion.fastCurve,
              builder: (BuildContext context, Color? color, Widget? child) {
                return MaunaIcon(
                  MaunaGlyphs.chevronDown(),
                  color: color!,
                  size: theme.metrics.smallIconSize,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MaunaToolbarChip extends StatefulWidget {
  const MaunaToolbarChip({
    super.key,
    this.icon,
    required this.label,
    required this.onPressed,
  });

  final Path? icon;

  final String label;

  final VoidCallback onPressed;

  @override
  State<MaunaToolbarChip> createState() => _MaunaToolbarChipState();
}

class _MaunaToolbarChipState extends State<MaunaToolbarChip> {
  bool _highlighted = false;

  void _setHighlighted(bool value) {
    setState(() => _highlighted = value);
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final Path? icon = widget.icon;
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: _setHighlighted,
        onShowFocusHighlight: _setHighlighted,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) => widget.onPressed(),
          ),
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: theme.motion.fast,
            curve: MaunaMotion.fastCurve,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.sm,
              vertical: theme.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.bgCanvas,
              border: Border.all(
                color: _highlighted ? theme.accent : theme.line,
                width: theme.metrics.borderWidth,
              ),
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                end: _highlighted ? theme.textPrimary : theme.textSecondary,
              ),
              duration: theme.motion.fast,
              curve: MaunaMotion.fastCurve,
              builder: (BuildContext context, Color? color, Widget? child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: theme.spacing.xs,
                  children: <Widget>[
                    if (icon != null)
                      MaunaIcon(
                        icon,
                        color: color!,
                        size: theme.metrics.chipIconSize,
                      ),
                    Text(
                      widget.label,
                      style: theme.captionStyle.copyWith(color: color),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
