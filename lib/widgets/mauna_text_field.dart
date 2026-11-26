import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_focus_ring.dart';

class MaunaTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: focusNode.requestFocus,
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
                        placeholder,
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
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          style: theme.uiStyle,
          cursorColor: theme.accent,
          backgroundCursorColor: theme.textSecondary,
          selectionColor: theme.selectionColor,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}
