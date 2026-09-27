import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/mauna_motion.dart';
import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';

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
  String barrierLabel = 'Закрыть',
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
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: MaunaMotion.baseCurve,
            ),
            child: child,
          );
        },
  );
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
    this.placeholder = 'Введите команду',
    this.emptyLabel = 'Нет подходящих команд',
  });

  final List<MaunaCommand> commands;

  final String placeholder;

  final String emptyLabel;

  @override
  State<MaunaCommandPalette> createState() => _MaunaCommandPaletteState();
}

class _MaunaCommandPaletteState extends State<MaunaCommandPalette> {
  final TextEditingController _query = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _highlighted = 0;

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
    setState(() => _highlighted = 0);
  }

  void _move(int delta) {
    final int count = _matches.length;
    if (count == 0) {
      return;
    }
    setState(() => _highlighted = (_highlighted + delta) % count);
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
            Padding(
              padding: EdgeInsets.all(theme.spacing.md),
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
            Container(height: theme.metrics.borderWidth, color: theme.line),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: theme.metrics.paletteMaxHeight,
              ),
              child: matches.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(theme.spacing.md),
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
    required this.onTap,
  });

  final String label;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Semantics(
      button: true,
      selected: highlighted,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: highlighted ? theme.bgCanvas : null,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.sm,
            ),
            child: Text(label, style: theme.uiStyle),
          ),
        ),
      ),
    );
  }
}
