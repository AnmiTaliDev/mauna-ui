import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_text_controller.dart';

class MaunaDocumentCanvas extends StatefulWidget {
  const MaunaDocumentCanvas({
    super.key,
    required this.controller,
    this.focusNode,
    this.placeholder,
    this.autofocus = false,
  });

  final MaunaTextController controller;

  final FocusNode? focusNode;

  final String? placeholder;

  final bool autofocus;

  @override
  State<MaunaDocumentCanvas> createState() => _MaunaDocumentCanvasState();
}

class _MaunaDocumentCanvasState extends State<MaunaDocumentCanvas>
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

  FocusNode? _ownFocusNode;
  Timer? _blinkTimer;
  bool _caretVisible = true;
  Rect? _caretRect;
  List<double> _ruleOffsets = <double>[];

  FocusNode get _focusNode => widget.focusNode ?? _ownFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _ownFocusNode = FocusNode();
    }
    widget.controller.addListener(_onEdit);
    _focusNode.addListener(_onFocusChange);
    _scheduleCaretUpdate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleCaretUpdate();
  }

  @override
  void didUpdateWidget(MaunaDocumentCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onEdit);
      widget.controller.addListener(_onEdit);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode!).removeListener(_onFocusChange);
      if (widget.focusNode == null) {
        _ownFocusNode ??= FocusNode();
      }
      _focusNode.addListener(_onFocusChange);
    }
    _scheduleCaretUpdate();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    widget.controller.removeListener(_onEdit);
    _focusNode.removeListener(_onFocusChange);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onEdit() {
    _restartBlink();
    _scheduleCaretUpdate();
  }

  void _onFocusChange() {
    _restartBlink();
    _scheduleCaretUpdate();
  }

  void _restartBlink() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    _caretVisible = true;
    if (!_focusNode.hasFocus) {
      return;
    }
    final Duration interval = MaunaThemeData.of(context).motion.cursorBlink;
    _blinkTimer = Timer.periodic(interval, (Timer timer) {
      setState(() => _caretVisible = !_caretVisible);
    });
  }

  void _scheduleCaretUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (!mounted) {
        return;
      }
      final EditableTextState? editable = editableTextKey.currentState;
      final TextSelection selection = widget.controller.selection;
      Rect? rect;
      if (editable != null && selection.isValid && selection.isCollapsed) {
        rect = editable.renderEditable.getLocalRectForCaret(selection.extent);
      }
      final List<double> rules = editable == null
          ? <double>[]
          : _titleRuleOffsets(editable.renderEditable);
      if (rect != _caretRect || !listEquals(rules, _ruleOffsets)) {
        setState(() {
          _caretRect = rect;
          _ruleOffsets = rules;
        });
      }
    });
  }

  List<double> _titleRuleOffsets(RenderEditable renderEditable) {
    if (!widget.controller.markup) {
      return <double>[];
    }
    final double gap = MaunaThemeData.of(context).spacing.xs;
    return <double>[
      for (final TextRange line in widget.controller.titleLines())
        renderEditable
                .getBoxesForSelection(
                  TextSelection(baseOffset: line.start, extentOffset: line.end),
                )
                .map((TextBox box) => box.bottom)
                .reduce(math.max) +
            gap,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final Rect? caret = _caretRect;
    final String? placeholder = widget.placeholder;

    return ColoredBox(
      color: theme.bgCanvas,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.lg,
          vertical: theme.spacing.xxl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: theme.metrics.documentColumnWidth,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  if (placeholder != null && widget.controller.text.isEmpty)
                    IgnorePointer(
                      child: Text(
                        placeholder,
                        style: theme.docStyle.copyWith(
                          color: theme.textSecondary,
                        ),
                      ),
                    ),
                  _gestures.buildGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: EditableText(
                      key: editableTextKey,
                      controller: widget.controller,
                      focusNode: _focusNode,
                      autofocus: widget.autofocus,
                      style: theme.docStyle,
                      strutStyle: widget.controller.markup
                          ? StrutStyle.disabled
                          : null,
                      cursorColor: theme.accent,
                      backgroundCursorColor: theme.textSecondary,
                      cursorWidth: theme.metrics.cursorWidth,
                      showCursor: false,
                      selectionColor: theme.selectionColor,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      rendererIgnoresPointer: true,
                    ),
                  ),
                  for (final double offset in _ruleOffsets)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: offset,
                      height: theme.metrics.borderWidth,
                      child: IgnorePointer(
                        child: ColoredBox(color: theme.line),
                      ),
                    ),
                  if (caret != null && _focusNode.hasFocus && _caretVisible)
                    Positioned(
                      left: caret.left,
                      top: caret.top,
                      width: theme.metrics.cursorWidth,
                      height: caret.height,
                      child: IgnorePointer(
                        child: ColoredBox(color: theme.accent),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
