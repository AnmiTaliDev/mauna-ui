## 0.2.0

- Command palette: the list scrolls to the row chosen with the arrow keys.
- Command palette: fuzzy search. Labels that contain the query come first, labels that only hold its letters in order come after them.
- `MaunaCommand.shortcut`: a key hint shown at the end of the palette row.
- Sidebar: the list scrolls to the selected item when `selectedIndex` changes.
- Sidebar: items can be dragged when `onReorder` is set. `canReorder` limits which items can be moved onto each other.
- Document canvas: a context menu with cut, copy, paste and select all. `contextMenuLabels` sets the item names.
- `MaunaTypeScale.copyWith` and `MaunaMetrics.copyWith`.

## 0.1.0

- First release: `MaunaThemeData` with light, dark, sepia and midnight presets, JSON serialization and WCAG AA checks.
- Widgets: toolbar, sidebar, document canvas with markup, status bar, popup, command palette and dialog.
- Stroke icons from Feather paths.
