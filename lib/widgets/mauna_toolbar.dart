import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';

class MaunaToolbar extends StatelessWidget {
  const MaunaToolbar({
    super.key,
    required this.children,
    this.hidden = false,
    this.dimmed = false,
  });

  final List<Widget> children;

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
        child: ExcludeFocus(
          excluding: hidden,
          child: Opacity(
            opacity: dimmed ? theme.metrics.dimmedChromeOpacity : 1,
            child: Container(
              height: theme.metrics.toolbarHeight,
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.sm),
              decoration: BoxDecoration(
                color: theme.bgChrome,
                border: Border(
                  bottom: BorderSide(
                    color: theme.line,
                    width: theme.metrics.borderWidth,
                  ),
                ),
              ),
              child: Row(spacing: theme.spacing.xs, children: children),
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

  final IconData? icon;

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

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool enabled = widget.onPressed != null;
    final Color foreground = !enabled
        ? theme.textSecondary
        : widget.accent
        ? theme.accent
        : theme.textPrimary;
    final bool highlighted = enabled && (_hovered || _focused);
    final double size = theme.metrics.toolbarHeight - 2 * theme.spacing.xs;

    final Widget content = widget.icon == null
        ? Text(widget.label, style: theme.uiStyle.copyWith(color: foreground))
        : Icon(widget.icon, size: theme.metrics.iconSize, color: foreground);

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
        onShowHoverHighlight: (bool value) => setState(() => _hovered = value),
        onShowFocusHighlight: (bool value) => setState(() => _focused = value),
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
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.sm),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted
                  ? theme.bgCanvas
                  : theme.bgCanvas.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
