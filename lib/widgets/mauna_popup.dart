import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_icon.dart';
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
        color: theme.bgChrome,
        border: Border.all(color: theme.line, width: theme.metrics.borderWidth),
        borderRadius: radius,
        boxShadow: <BoxShadow>[theme.popupShadow],
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: theme.metrics.dialogWidth),
      child: MaunaPopup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: theme.metrics.toolbarHeight,
              padding: EdgeInsets.only(
                left: theme.spacing.md,
                right: theme.spacing.xs,
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
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: theme.uiStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  MaunaToolbarButton(
                    icon: MaunaGlyphs.close(),
                    label: closeLabel,
                    onPressed: () => _close(context),
                  ),
                ],
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

class MaunaCommand {
  const MaunaCommand({required this.label, required this.onSelected});

  final String label;

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

class _MaunaCommandPaletteState extends State<MaunaCommandPalette> {
  final MaunaTextController _query = MaunaTextController();
  final FocusNode _focusNode = FocusNode();
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
    super.dispose();
  }

  List<MaunaCommand> get _matches {
    final String query = _query.text.toLowerCase();
    return <MaunaCommand>[
      for (final MaunaCommand command in widget.commands)
        if (command.label.toLowerCase().contains(query)) command,
    ];
  }

  void _onQueryChanged() {
    if (_query.text == _lastQuery) {
      return;
    }
    _lastQuery = _query.text;
    setState(() => _highlighted = 0);
  }

  void _move(int delta) {
    final int count = _matches.length;
    if (count == 0) {
      return;
    }
    setState(() => _highlighted = (_highlighted + delta) % count);
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

    return MaunaPopup(
      child: SizedBox(
        width: theme.metrics.paletteWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(theme.spacing.sm),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.line,
                    width: theme.metrics.borderWidth,
                  ),
                ),
              ),
              child: CallbackShortcuts(
                bindings: <ShortcutActivator, VoidCallback>{
                  const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                      _move(1),
                  const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                      _move(-1),
                  const SingleActivator(LogicalKeyboardKey.escape): () =>
                      Navigator.of(context).pop(),
                },
                child: Stack(
                  children: <Widget>[
                    if (_query.text.isEmpty)
                      IgnorePointer(
                        child: Text(
                          widget.placeholder,
                          style: theme.uiStyle.copyWith(
                            color: theme.textSecondary,
                          ),
                        ),
                      ),
                    EditableText(
                      controller: _query,
                      focusNode: _focusNode,
                      autofocus: true,
                      style: theme.uiStyle,
                      cursorColor: theme.accent,
                      backgroundCursorColor: theme.textSecondary,
                      cursorWidth: theme.metrics.cursorWidth,
                      selectionColor: theme.selectionColor,
                      onSubmitted: (String value) => _runHighlighted(),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: theme.metrics.paletteMaxHeight,
              ),
              child: matches.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.md,
                        vertical: theme.spacing.sm,
                      ),
                      child: Text(
                        widget.emptyLabel,
                        style: theme.uiStyle.copyWith(
                          color: theme.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: theme.spacing.xs),
                      itemCount: matches.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _CommandRow(
                          label: matches[index].label,
                          highlighted: index == _highlighted,
                          onHover: () => _highlight(index),
                          onTap: () => _run(matches[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  const _CommandRow({
    required this.label,
    required this.highlighted,
    required this.onHover,
    required this.onTap,
  });

  final String label;
  final bool highlighted;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Semantics(
      button: true,
      selected: highlighted,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (PointerEnterEvent event) => onHover(),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: highlighted ? theme.bgCanvas : null,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.metrics.listItemPaddingY,
            ),
            child: Text(
              label,
              style: theme.uiStyle.copyWith(
                color: highlighted ? theme.textPrimary : theme.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
