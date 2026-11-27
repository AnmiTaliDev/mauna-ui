import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_command_filter.dart';
import 'mauna_icon.dart';
import 'mauna_menu.dart';
import 'mauna_text_controller.dart';
import 'mauna_toolbar.dart';

class MaunaPopup extends StatelessWidget {
  const MaunaPopup({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final BorderRadius radius = BorderRadius.circular(theme.radiusLg);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.bgCard,
        border: Border.all(color: theme.line, width: theme.metrics.borderWidth),
        borderRadius: radius,
        boxShadow: theme.popupShadows,
      ),
      child: ClipRRect(borderRadius: radius, child: child),
    );
  }
}

Future<T?> showMaunaPopup<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String barrierLabel = 'Close',
}) {
  final MaunaThemeData theme = MaunaThemeData.of(context);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: barrierLabel,
    barrierColor: theme.bgCanvas.withValues(alpha: 0),
    transitionDuration: theme.motion.base,
    pageBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: theme.spacing.xxxl),
                child: builder(context),
              ),
            ),
          );
        },
    transitionBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          final Animation<double> curved = CurvedAnimation(
            parent: animation,
            curve: MaunaMotion.baseCurve,
          );
          return FadeTransition(
            opacity: curved,
            child: AnimatedBuilder(
              animation: curved,
              child: child,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(0, -theme.spacing.sm * (1 - curved.value)),
                  child: child,
                );
              },
            ),
          );
        },
  );
}

Future<T?> showMaunaDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String barrierLabel = 'Close',
}) {
  final MaunaThemeData theme = MaunaThemeData.of(context);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: barrierLabel,
    barrierColor: const Color(
      0xFF000000,
    ).withValues(alpha: theme.metrics.modalBarrierOpacity),
    transitionDuration: theme.motion.base,
    pageBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.md),
                child: builder(context),
              ),
            ),
          );
        },
    transitionBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          final Animation<double> curved = CurvedAnimation(
            parent: animation,
            curve: MaunaMotion.baseCurve,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: theme.metrics.dialogEnterScale,
                end: 1,
              ).animate(curved),
              child: child,
            ),
          );
        },
  );
}

class MaunaDialog extends StatelessWidget {
  const MaunaDialog({
    super.key,
    required this.title,
    required this.child,
    this.closeLabel = 'Close',
  });

  final String title;

  final Widget child;

  final String closeLabel;

  void _close(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final double side = theme.metrics.toolbarButtonSize + theme.spacing.sm;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: theme.metrics.dialogWidth),
      child: MaunaPopup(
        child: ColoredBox(
          color: theme.bgChrome,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: theme.metrics.toolbarHeight,
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.sm),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.line,
                      width: theme.metrics.borderWidth,
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: side),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.uiStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: side,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: MaunaToolbarButton(
                          icon: MaunaGlyphs.close(),
                          label: closeLabel,
                          onPressed: () => _close(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class MaunaCommand {
  const MaunaCommand({
    required this.label,
    required this.onSelected,
    this.shortcut,
  });

  final String label;

  final String? shortcut;

  final VoidCallback onSelected;
}

class MaunaCommandPalette extends StatefulWidget {
  const MaunaCommandPalette({
    super.key,
    required this.commands,
    this.placeholder = 'Enter a command',
    this.emptyLabel = 'No matching commands',
  });

  final List<MaunaCommand> commands;

  final String placeholder;

  final String emptyLabel;

  @override
  State<MaunaCommandPalette> createState() => _MaunaCommandPaletteState();
}

class _MaunaCommandPaletteState extends State<MaunaCommandPalette>
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

  final MaunaTextController _query = MaunaTextController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scroll = ScrollController();
  final GlobalKey _highlightedRow = GlobalKey();
  int _highlighted = 0;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _query.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _query.dispose();
    _focusNode.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<MaunaCommand> get _matches =>
      filterCommands(widget.commands, _query.text);

  void _onQueryChanged() {
    if (_query.text == _lastQuery) {
      return;
    }
    _lastQuery = _query.text;
    setState(() => _highlighted = 0);
    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  void _move(int delta) {
    final int count = _matches.length;
    if (count == 0) {
      return;
    }
    setState(() => _highlighted = (_highlighted + delta) % count);
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _revealHighlighted();
    });
  }

  void _revealHighlighted() {
    final BuildContext? row = _highlightedRow.currentContext;
    if (row == null) {
      return;
    }
    for (final ScrollPositionAlignmentPolicy policy
        in <ScrollPositionAlignmentPolicy>[
          ScrollPositionAlignmentPolicy.keepVisibleAtStart,
          ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        ]) {
      Scrollable.ensureVisible(row, alignmentPolicy: policy);
    }
  }

  void _highlight(int index) {
    setState(() => _highlighted = index);
  }

  void _run(MaunaCommand command) {
    Navigator.of(context).pop();
    command.onSelected();
  }

  void _runHighlighted() {
    final List<MaunaCommand> matches = _matches;
    if (matches.isNotEmpty) {
      _run(matches[_highlighted]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final List<MaunaCommand> matches = _matches;

    final TextStyle queryStyle = theme.uiStyle.copyWith(
      fontSize: theme.typeScale.heading,
    );
    final EdgeInsets inset = EdgeInsets.all(theme.metrics.menuInset);

    return MaunaPopup(
      child: SizedBox(
        width: theme.metrics.paletteWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.lg,
                vertical: theme.spacing.md,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.line,
                    width: theme.metrics.borderWidth,
                  ),
                ),
              ),
              child: Row(
                spacing: theme.spacing.md,
                children: <Widget>[
                  MaunaIcon(MaunaGlyphs.search(), color: theme.textSecondary),
                  Expanded(
                    child: CallbackShortcuts(
                      bindings: <ShortcutActivator, VoidCallback>{
                        const SingleActivator(
                          LogicalKeyboardKey.arrowDown,
                        ): () =>
                            _move(1),
                        const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                            _move(-1),
                        const SingleActivator(LogicalKeyboardKey.escape): () =>
                            Navigator.of(context).pop(),
                      },
                      child: _gestures.buildGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Stack(
                          children: <Widget>[
                            if (_query.text.isEmpty)
                              IgnorePointer(
                                child: Text(
                                  widget.placeholder,
                                  style: queryStyle.copyWith(
                                    color: theme.textSecondary,
                                  ),
                                ),
                              ),
                            EditableText(
                              key: editableTextKey,
                              controller: _query,
                              focusNode: _focusNode,
                              autofocus: true,
                              style: queryStyle,
                              cursorColor: theme.accent,
                              backgroundCursorColor: theme.textSecondary,
                              cursorWidth: theme.metrics.cursorWidth,
                              selectionColor: theme.selectionColor,
                              onSubmitted: (String value) => _runHighlighted(),
                              rendererIgnoresPointer: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: theme.metrics.paletteMaxHeight,
              ),
              child: matches.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.lg,
                        vertical: theme.spacing.md,
                      ),
                      child: Text(
                        widget.emptyLabel,
                        style: theme.uiStyle.copyWith(
                          color: theme.textSecondary,
                        ),
                      ),
                    )
                  : Padding(
                      padding: inset,
                      child: SingleChildScrollView(
                        controller: _scroll,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            for (int i = 0; i < matches.length; i++)
                              KeyedSubtree(
                                key: i == _highlighted ? _highlightedRow : null,
                                child: MaunaMenuItem(
                                  label: matches[i].label,
                                  shortcut: matches[i].shortcut,
                                  highlighted: i == _highlighted,
                                  onHover: () => _highlight(i),
                                  onTap: () => _run(matches[i]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
