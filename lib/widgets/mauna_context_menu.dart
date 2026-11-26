import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import '../theme/mauna_typography.dart';
import 'mauna_popup.dart';

class MaunaContextMenuLabels {
  const MaunaContextMenuLabels({
    this.cut = 'Cut',
    this.copy = 'Copy',
    this.paste = 'Paste',
    this.selectAll = 'Select all',
  });

  final String cut;

  final String copy;

  final String paste;

  final String selectAll;

  String? of(ContextMenuButtonType type) {
    return switch (type) {
      ContextMenuButtonType.cut => cut,
      ContextMenuButtonType.copy => copy,
      ContextMenuButtonType.paste => paste,
      ContextMenuButtonType.selectAll => selectAll,
      _ => null,
    };
  }
}

const double _menuWidth = 200;

class MaunaContextMenu extends StatelessWidget {
  const MaunaContextMenu({
    super.key,
    required this.anchor,
    required this.items,
    required this.labels,
  });

  final Offset anchor;

  final List<ContextMenuButtonItem> items;

  final MaunaContextMenuLabels labels;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return CustomSingleChildLayout(
      delegate: DesktopTextSelectionToolbarLayoutDelegate(anchor: anchor),
      child: TextFieldTapRegion(
        child: SizedBox(
          width: _menuWidth,
          child: MaunaPopup(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: theme.spacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final ContextMenuButtonItem item in items)
                    if (labels.of(item.type) case final String label)
                      _ContextMenuRow(label: label, onTap: item.onPressed),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContextMenuRow extends StatefulWidget {
  const _ContextMenuRow({required this.label, required this.onTap});

  final String label;

  final VoidCallback? onTap;

  @override
  State<_ContextMenuRow> createState() => _ContextMenuRowState();
}

class _ContextMenuRowState extends State<_ContextMenuRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Semantics(
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Container(
            color: _hovered ? theme.bgCanvas : null,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.metrics.listItemPaddingY,
            ),
            child: Text(
              widget.label,
              style: theme.uiStyle.copyWith(
                color: _hovered ? theme.textPrimary : theme.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
