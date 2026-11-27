import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_focus_ring.dart';

class MaunaTextField extends StatefulWidget {
  const MaunaTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;

  final FocusNode focusNode;

  final String placeholder;

  final ValueChanged<String>? onSubmitted;

  final ValueChanged<String>? onChanged;

  final bool autofocus;

  @override
  State<MaunaTextField> createState() => _MaunaTextFieldState();
}

class _MaunaTextFieldState extends State<MaunaTextField>
    implements TextSelectionGestureDetectorBuilderDelegate {
  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  late final TextSelectionGestureDetectorBuilder _gestures =
      TextSelectionGestureDetectorBuilder(delegate: this);

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final TextEditingController controller = widget.controller;
    final FocusNode focusNode = widget.focusNode;
    return _gestures.buildGestureDetector(
      behavior: HitTestBehavior.opaque,
      child: ListenableBuilder(
        listenable: Listenable.merge(<Listenable>[controller, focusNode]),
        builder: (BuildContext context, Widget? field) {
          return MaunaFocusRing(
            visible: focusNode.hasFocus,
            radius: theme.radiusSm,
            child: Container(
              height: theme.metrics.controlHeight,
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.sm),
              decoration: BoxDecoration(
                color: theme.bgCard,
                borderRadius: BorderRadius.circular(theme.radiusSm),
                border: Border.all(
                  color: theme.line,
                  width: theme.metrics.borderWidth,
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Stack(
                children: <Widget>[
                  if (controller.text.isEmpty)
                    IgnorePointer(
                      child: Text(
                        widget.placeholder,
                        maxLines: 1,
                        style: theme.uiStyle.copyWith(
                          color: theme.textSecondary,
                        ),
                      ),
                    ),
                  field!,
                ],
              ),
            ),
          );
        },
        child: EditableText(
          key: editableTextKey,
          controller: controller,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          style: theme.uiStyle,
          cursorColor: theme.accent,
          backgroundCursorColor: theme.textSecondary,
          selectionColor: theme.selectionColor,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          rendererIgnoresPointer: true,
        ),
      ),
    );
  }
}
