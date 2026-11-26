import 'package:flutter/widgets.dart';

typedef MaunaPressableBuilder =
    Widget Function(BuildContext context, bool hovered, bool focused);

class MaunaPressable extends StatefulWidget {
  const MaunaPressable({
    super.key,
    required this.onPressed,
    required this.builder,
    this.autofocus = false,
  });

  final VoidCallback? onPressed;

  final MaunaPressableBuilder builder;

  final bool autofocus;

  @override
  State<MaunaPressable> createState() => _MaunaPressableState();
}

class _MaunaPressableState extends State<MaunaPressable> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) {
    setState(() => _hovered = value);
  }

  void _setFocused(bool value) {
    setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;
    return FocusableActionDetector(
      enabled: enabled,
      autofocus: widget.autofocus,
      mouseCursor: SystemMouseCursors.basic,
      onShowHoverHighlight: _setHovered,
      onShowFocusHighlight: _setFocused,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) => widget.onPressed?.call(),
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: widget.builder(
          context,
          enabled && _hovered,
          enabled && _focused,
        ),
      ),
    );
  }
}
