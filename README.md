# mauna

## About

Flutter package with the theme tokens and base widgets of the Mauna design system. It is for writing apps built around a text editor that follow the [Mauna HIG](https://github.com/AnmiTaliDev/mauna-hig).

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
  darkTheme: MaunaThemeData.dark(accent: MaunaAccents.coolTeal.dark).toMaterialTheme(),
  home: ...,
);
```

Widgets read tokens with `MaunaThemeData.of(context)`. A theme loaded from JSON is built with `MaunaThemeData.fromJson(map)`, and `toJson()` produces the same format.

`MaunaDocumentCanvas` and the command palette take a `MaunaTextController`. It paints selected text in `textOnAccent` on top of the solid `accent` selection, since `EditableText` has no separate color for selected text.

With `MaunaTextController(markup: true)` the canvas styles the document like the document column of the HIG site:

- `# ` lines use `titleStyle` with a 0.5px `line` rule below. `## ` lines use `headingStyle`.
- `**text**` is Courier Prime Bold. `` `text` `` is set at `typeScale.inlineCodeScale` on `bg.chrome`.
- Markers are hidden on lines without the caret and shown in `text.secondary` on the caret line.
- Blank lines between blocks take `space.md`.

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
| Selected text on `accent` | `MaunaThemeData.textOnAccent` |
| `font.doc` / `font_doc` | `MaunaThemeData.fontDoc` |
| `font.ui` / `font_ui` | `MaunaThemeData.fontUi` |
| `line_height_doc` | `MaunaThemeData.lineHeightDoc` |
| `line_height_ui` | `MaunaThemeData.lineHeightUi` |
| `radius.sm` / `radius_sm` | `MaunaThemeData.radiusSm` |
| `radius.lg` / `radius_lg` | `MaunaThemeData.radiusLg` |
| `type.caption` | `typeScale.caption`, `captionStyle` |
| `type.ui` | `typeScale.ui`, `uiStyle` |
| `type.doc` | `typeScale.doc`, `docStyle` |
| `type.heading` | `typeScale.heading`, `headingStyle` |
| `type.title` | `typeScale.title`, `typeScale.lineHeightTitle`, `titleStyle` |
| `space.xs` ... `space.lg` | `spacing.xs` ... `spacing.lg` |
| `space.xl` | `spacing.xl` |
| `space.2xl` | `spacing.xxl` |
| `space.3xl` | `spacing.xxxl` |
| `motion.fast` | `motion.fast`, `MaunaMotion.fastCurve` |
| `motion.base` | `motion.base`, `MaunaMotion.baseCurve` |
| `motion.slow` | `motion.slow`, `MaunaMotion.slowCurve` |
| Caret blink 530ms | `motion.cursorBlink` |
| Toolbar height 40px | `metrics.toolbarHeight` |
| Toolbar button 28px | `metrics.toolbarButtonSize` |
| Status bar height 28px | `metrics.statusBarHeight` |
| Sidebar width 170-200px | `metrics.sidebarWidth` (200, as in `tokens.css`) |
| Document column about 620px | `metrics.documentColumnWidth` |
| Border 0.5px | `metrics.borderWidth` |
| Caret 2px | `metrics.cursorWidth` |
| Icon 16-20px | `metrics.iconSize` (18) |
| Icon stroke 1.5px | `metrics.iconStrokeWidth` |
| Popup shadow `0 2px 8px` | `metrics.popupShadowOffsetY`, `metrics.popupShadowBlur`, `popupShadowOpacity`, `popupShadow` |
| Accent options | `MaunaAccents.steelBlue`, `graphite`, `coolTeal`, `indigo` (`.light` and `.dark`) |
| Presets Paper, Ink, Sepia, Midnight | `MaunaThemeData.light`, `.dark`, `.sepia`, `.midnight` |

JSON keys for the C struct fields match the HIG snake_case names. The remaining groups are nested under `type`, `space`, `motion` and `metrics`.

## Values from the HIG reference implementation

The HIG text does not describe states and paddings. These come from the HIG site sources (`src/styles`, `src/components`):

- Toolbar: `space.md` side padding, left and right groups with `space.xs` gaps, 28px buttons in `text.secondary`. Hover and keyboard focus switch to `text.primary` with a `bg.canvas` fill and `radius.sm`. The accent button draws its glyph in `accent`.
- Focus mode: the toolbar slides up and fades out over `motion.slow`. `MaunaToolbarRestoreButton` (24px, 0.5px border, 14px chevron) brings it back.
- Sidebar and palette rows: `text.secondary`, `text.primary` on hover, 6px vertical padding, 2px gaps. The active sidebar row adds `bg.canvas` and Medium weight. The optional sidebar title is an uppercase caption with 0.5px letter spacing (`labelStyle`).
- Popup and palette: 0.5px `line` border in addition to the shadow. The palette slides down by `space.sm` while it fades in.
- Dialog: 40px header with a bottom border, black barrier at 0.4, scale from 0.97 over `motion.base`.
- Status bar: `bg.chrome`, `space.md` side padding, left and right groups, items separated by `|` at 0.4 opacity.
- Selection: solid `accent` with `#FBFAF7` text in light themes and `#1C1B19` in dark themes.
- Canvas padding: `space.2xl` vertical, `space.lg` horizontal.
- The caret toggles every 530ms, a 1060ms cycle.

## Deviations from the HIG

These values differ from the HIG or fill gaps that neither the text nor the reference implementation covers:

- Light `text.secondary` is `#5F6E84` instead of `#64748B`. The HIG value is 4.23:1 on `bg.chrome`. The new value passes 4.5:1 on canvas and chrome, and the theme asserts both pairs.
- Accents are light and dark pairs. One hex cannot reach 4.5:1 on both base themes. Each variant passes 4.5:1 on canvas and chrome of every preset with the same brightness, and `textOnAccent` passes 4.5:1 on each of them.

| Accent | Light | Dark |
|---|---|---|
| Steel blue | `#36669B` | `#5B8FC7` |
| Graphite | `#5A5D66` | `#858994` |
| Cool teal | `#226F64` | `#2F9A8A` |
| Indigo | `#5156C4` | `#7F82D3` |

- Sepia preset: canvas `#F4EEE1`, chrome `#EAE2D1`, text `#2B2620` / `#6D6254`, line `#DCD2BE`, light accents, shadow alpha 0.08.
- Midnight preset: canvas `#0E1117`, chrome `#151A23`, text `#DDE3EC` / `#7F8A9A`, line `#252C38`, dark accents, shadow alpha 0.04.
- `metrics.dimmedChromeOpacity` (0.5): opacity of chrome in focus mode.
- `metrics.paletteWidth` (480) and `metrics.paletteMaxHeight` (320). The reference palette is 320px wide inside a small sandbox.
- Palette rows use `type.ui` (14px). The reference uses 13px, which is not on the type scale.
- `metrics.focusRingWidth` (1): sidebar rows show a keyboard focus ring in `text.secondary`.
- Disabled toolbar buttons use `text.secondary` at half opacity.
- `headingStyle` and `titleStyle` use Medium weight.
- Document placeholder in `text.secondary`. The popup sits `space.3xl` below the top edge with a transparent barrier.

## Icons

Icon fonts cannot be drawn with a fixed stroke width, so toolbar buttons take a `Path` on a 24-unit grid instead of `IconData`. `MaunaIcon` scales the path to `metrics.iconSize` and strokes it at `metrics.iconStrokeWidth` screen pixels. `MaunaGlyphs` has `file`, `save`, `search`, `focus`, `download`, `menu`, `settings`, `sidebar`, `command`, `chevronDown`, `close`, `check`, `sun` and `moon`. The paths are the Feather icons used by the HIG site. Other glyphs are plain `Path` objects on the same grid.

`MaunaToolbarChip` is the bordered icon and caption button from the HIG site toolbar ("Settings").

## Acknowledgments

- Glyph paths from Feather Icons (MIT)

- Courier Prime and Inter (SIL OFL 1.1), JetBrains Mono (Apache 2.0)

## Documentation

- Design guidelines: <https://github.com/AnmiTaliDev/mauna-hig>

## License

Apache License 2.0. See [LICENSE](LICENSE).
