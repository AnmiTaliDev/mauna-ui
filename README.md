# mauna

## About

Flutter package with the theme tokens and base widgets of the Mauna design system. It is for writing apps built around a text editor. The structure of the tokens comes from the [Mauna HIG](https://github.com/AnmiTaliDev/mauna-hig). Since 0.3.0 the look is quieter and closer to macOS, and many values differ from the HIG.

## Dependencies

- Flutter 3.32 or newer (Dart 3.8 or newer)
- No runtime packages beyond the Flutter SDK
- `flutter_lints` for development

## Build

```sh
flutter pub get
flutter analyze
flutter test
```

## Demo

`example/` holds a small editor built from the package widgets. It bundles Courier Prime and Inter in `example/fonts` with their OFL license texts. Platform folders are not committed. Generate them once, then run:

```sh
cd example
flutter create --platforms=linux,macos,windows .
flutter run -d linux
```

Shortcuts: Ctrl+K opens the command palette, Ctrl+B toggles the sidebar, Ctrl+, opens settings, Ctrl+Shift+F toggles focus mode, Escape leaves focus mode. In focus mode the button in the top right corner brings the toolbar back. Lines starting with `# ` appear in the sidebar. The panels dim while you type and return to full contrast when the pointer moves.

## Usage

```dart
MaterialApp(
  theme: MaunaThemeData.light().toMaterialTheme(),
  darkTheme: MaunaThemeData.dark(accent: MaunaAccents.coolTeal).toMaterialTheme(),
  home: ...,
);
```

Widgets read tokens with `MaunaThemeData.of(context)`. A theme loaded from JSON is built with `MaunaThemeData.fromJson(map)`, and `toJson()` produces the same format.

`MaunaDocumentCanvas` and the command palette take a `MaunaTextController`. Selected text keeps its color on top of `selectionColor`, a translucent tint of the accent.

With `MaunaTextController(markup: true)` the canvas styles the document like the document column of the HIG site:

- `# ` lines use `titleStyle` with a `line` rule below. `## ` lines use `headingStyle`.
- `**text**` is Courier Prime Bold. `` `text` `` is set at `typeScale.inlineCodeScale` on `fill`.
- Markers are hidden on lines without the caret and shown in `text.secondary` on the caret line.
- Blank lines between blocks take `space.md`.

The command palette matches commands fuzzily and shows the optional `MaunaCommand.shortcut`. `MaunaSidebar` keeps the selected item in view, and with `onReorder` its items can be dragged. `MaunaDocumentCanvas` has a context menu whose names come from `contextMenuLabels`.

## Controls

`MaunaButton`, `MaunaSwitch`, `MaunaSegmentedControl` and `MaunaTextField` are the controls. `MaunaFormSection` groups `MaunaFormRow` entries on a card, for settings. `MaunaMenu`, `MaunaMenuItem` and `MaunaMenuSeparator` build menus. `MaunaPressable` and `MaunaFocusRing` give custom controls the same pointer, keyboard and focus behaviour. `MaunaToolbar.center` holds a window title or a drag area.

## Fonts

The package does not bundle font files and does not use `google_fonts`. The theme refers to families by name: `Courier Prime` (or `JetBrains Mono`) for `font.doc` and `Inter` for `font.ui`. The app declares them in its own `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Courier Prime
      fonts:
        - asset: fonts/CourierPrime-Regular.ttf
        - asset: fonts/CourierPrime-Bold.ttf
          weight: 700
        - asset: fonts/CourierPrime-Italic.ttf
          style: italic
        - asset: fonts/CourierPrime-BoldItalic.ttf
          weight: 700
          style: italic
    - family: Inter
      fonts:
        - asset: fonts/Inter-Regular.ttf
        - asset: fonts/Inter-Medium.ttf
          weight: 500
```

Without these entries the text styles fall back to the lists in `MaunaFonts.docFallback` and `MaunaFonts.uiFallback`, the same order as `tokens.css` in the HIG repository.

## Token mapping

| HIG token | Dart |
|---|---|
| `bg.canvas` / `bg_canvas` | `MaunaThemeData.bgCanvas` |
| `bg.chrome` / `bg_chrome` | `MaunaThemeData.bgChrome` |
| `text.primary` / `text_primary` | `MaunaThemeData.textPrimary` |
| `text.secondary` / `text_secondary` | `MaunaThemeData.textSecondary` |
| `line` | `MaunaThemeData.line` |
| `accent` | `MaunaThemeData.accent` |
| `font.doc` / `font_doc` | `MaunaThemeData.fontDoc` |
| `font.ui` / `font_ui` | `MaunaThemeData.fontUi` |
| `line_height_doc` | `MaunaThemeData.lineHeightDoc` |
| `line_height_ui` | `MaunaThemeData.lineHeightUi` |
| `radius.sm` / `radius_sm` | `MaunaThemeData.radiusSm` |
| `radius.lg` / `radius_lg` | `MaunaThemeData.radiusLg` |
| `type.caption` ... `type.title` | `typeScale`, `captionStyle`, `uiStyle`, `docStyle`, `headingStyle`, `titleStyle` |
| `space.xs` ... `space.lg`, `space.xl` | `spacing.xs` ... `spacing.lg`, `spacing.xl` |
| `space.2xl`, `space.3xl` | `spacing.xxl`, `spacing.xxxl` |
| `motion.fast`, `motion.base`, `motion.slow` | `motion`, `MaunaMotion` curves |

Tokens that the HIG does not have: `bgCard` (cards, menus, dialogs on top of the window), `bgControl` (buttons and the selected segment), `fill` (translucent hover and selection), `accentFill` (filled elements that carry `textOnAccent`).

JSON keys for the C struct fields match the HIG snake_case names. The remaining groups are nested under `type`, `space`, `motion` and `metrics`.

## Differences from the HIG

- Surfaces are neutral gray instead of blue gray. Sepia and Midnight keep their tint.
- The interface text is 13px, captions 11px, headings 17px and titles 26px. Radii are 6px and 10px.
- Borders are 1px in a light `line` color. Popups have a wide soft shadow.
- The toolbar is 44px and uses `bgCanvas`. The status bar is 26px without a border.
- The selection is a translucent tint. Menu and palette rows are filled with `accentFill` when highlighted.
- Accents have three colors: for light themes, for dark themes and for fills. Each passes WCAG AA for the way it is used, and the theme tests check every preset.

| Accent | Light | Dark | Fill |
|---|---|---|---|
| Steel blue | `#0064CC` | `#4DA3FF` | `#0A68D8` |
| Graphite | `#55555A` | `#B0B0B6` | `#6C6C72` |
| Cool teal | `#0C6B62` | `#45C4B0` | `#10766C` |
| Indigo | `#4B45C6` | `#A5A2FA` | `#5651D2` |

## Icons

Icon fonts cannot be drawn with a fixed stroke width, so toolbar buttons take a `Path` on a 24-unit grid instead of `IconData`. `MaunaIcon` scales the path to `metrics.iconSize` and strokes it at `metrics.iconStrokeWidth` screen pixels. `MaunaGlyphs` has `file`, `save`, `search`, `focus`, `download`, `menu`, `settings`, `sidebar`, `command`, `chevronDown`, `close`, `check`, `sun` and `moon`. The paths are the Feather icons used by the HIG site. Other glyphs are plain `Path` objects on the same grid.

## Acknowledgments

- Glyph paths from Feather Icons (MIT)

- Courier Prime and Inter (SIL OFL 1.1), JetBrains Mono (Apache 2.0)

## Documentation

- Design guidelines: <https://github.com/AnmiTaliDev/mauna-hig>

## License

Apache License 2.0. See [LICENSE](LICENSE).
