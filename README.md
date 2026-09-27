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

## Usage

```dart
MaterialApp(
  theme: MaunaThemeData.light().toMaterialTheme(),
  darkTheme: MaunaThemeData.dark(accent: MaunaAccents.coolTeal).toMaterialTheme(),
  home: ...,
);
```

Widgets read tokens with `MaunaThemeData.of(context)`. A theme loaded from JSON is built with `MaunaThemeData.fromJson(map)`, and `toJson()` produces the same format.

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

Without these entries Flutter falls back to the platform font.

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
| Status bar height 28px | `metrics.statusBarHeight` |
| Sidebar width 170-200px | `metrics.sidebarWidth` (184) |
| Document column about 620px | `metrics.documentColumnWidth` |
| Border 0.5px | `metrics.borderWidth` |
| Caret 2px | `metrics.cursorWidth` |
| Icon 16-20px | `metrics.iconSize` (18) |
| Popup shadow `0 2px 8px` | `metrics.popupShadowOffsetY`, `metrics.popupShadowBlur`, `popupShadowOpacity`, `popupShadow` |
| Accent options | `MaunaAccents.steelBlue`, `graphite`, `coolTeal`, `indigo` |

JSON keys for the C struct fields match the HIG snake_case names. The remaining groups are nested under `type`, `space`, `motion` and `metrics`.

## Values not defined by the HIG

These values are inferred from the HIG principles:

- `metrics.dimmedChromeOpacity` (0.5): opacity of chrome in focus mode.
- `metrics.selectionOpacity` (0.25): alpha of the `accent` selection fill.
- `metrics.paletteWidth` (480) and `metrics.paletteMaxHeight` (320).
- Hover and keyboard focus on toolbar buttons: `bg.canvas` fill with `radius.sm`. Disabled buttons use `text.secondary`.
- The status bar fill is `bg.canvas`, because `text.secondary` on `bg.chrome` in the light theme is 4.23:1, below WCAG AA.
- `headingStyle` and `titleStyle` use Medium weight.
- Sidebar right border and status bar top border: 0.5px `line`, like the toolbar bottom border.
- Document placeholder in `text.secondary`. Vertical page padding `space.3xl`.
- Popup barrier is transparent. The popup sits `space.3xl` below the top edge.
- Command palette: highlighted row uses the `bg.canvas` fill, and a 0.5px `line` divider separates the field and the list.
- The caret blink value (530ms) is the interval between visibility toggles.

## Known limitations

- Icon stroke width (1.5px, HIG §7) cannot be set on font glyphs. Pass outline glyphs drawn at that stroke.
- Sidebar items respond to pointer input only. They are not in the keyboard focus order.

## Acknowledgments

- [Mauna HIG](https://github.com/AnmiTaliDev/mauna-hig)
- Courier Prime, Inter (SIL OFL 1.1) and JetBrains Mono (Apache 2.0), used by name

## Documentation

- Design guidelines: <https://github.com/AnmiTaliDev/mauna-hig>
- CONTRIBUTING.md is not written yet.

## License

Apache License 2.0. See [LICENSE](LICENSE).
