## 0.3.1

- Fix: `MaunaTextField` and the command palette query select text with the mouse: drag, double click and triple click.

## 0.3.0

New look: neutral colors and compact controls in the style of macOS before Liquid Glass. The values no longer match the Mauna HIG.

- Breaking: the theme factories take a `MaunaAccent` instead of a `Color`. `MaunaAccent` has a new `fill` color for filled elements.
- Breaking: new theme tokens `bgCard`, `bgControl`, `fill` and `accentFill`, also required in JSON. `popupShadow` is replaced by `popupShadows`.
- Breaking: `MaunaMetrics` has new fields. `chipIconSize` and `separatorOpacity` are removed.
- Breaking: `MaunaToolbarChip` is removed. Use `MaunaButton`.
- Selection is a translucent tint of the accent and keeps the text color.
- New widgets: `MaunaButton`, `MaunaSwitch`, `MaunaSegmentedControl`, `MaunaTextField`, `MaunaFormSection`, `MaunaFormRow`, `MaunaMenu`, `MaunaMenuItem`, `MaunaMenuSeparator`, `MaunaPressable` and `MaunaFocusRing`.
- `MaunaToolbar.center` takes a widget between the two button groups, for a window title.
- The command palette, the context menu and the menus share the same rows. The highlighted row is filled with the accent.
- Sidebar rows are inset and rounded, and long titles are cut to one line. The title is no longer uppercased.
- The status bar has no border and no separators.
- Dialog titles are centered.

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
