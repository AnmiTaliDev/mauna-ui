import 'package:flutter/widgets.dart';

import '../theme/mauna_theme_data.dart';
import 'mauna_menu.dart';

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

class MaunaContextMenu extends StatefulWidget {
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
  State<MaunaContextMenu> createState() => _MaunaContextMenuState();
}

class _MaunaContextMenuState extends State<MaunaContextMenu> {
  ContextMenuButtonType? _hovered;

  void _setHovered(ContextMenuButtonType? type) {
    setState(() => _hovered = type);
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return CustomSingleChildLayout(
      delegate: DesktopTextSelectionToolbarLayoutDelegate(
        anchor: widget.anchor,
      ),
      child: TextFieldTapRegion(
        child: SizedBox(
          width: theme.metrics.menuWidth,
          child: MaunaMenu(
            children: <Widget>[
              for (final ContextMenuButtonItem item in widget.items)
                if (widget.labels.of(item.type) case final String label)
                  MaunaMenuItem(
                    label: label,
                    highlighted: _hovered == item.type,
                    onHover: () => _setHovered(item.type),
                    onExit: () => _setHovered(null),
                    onTap: item.onPressed,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
