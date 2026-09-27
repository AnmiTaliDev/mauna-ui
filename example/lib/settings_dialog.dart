import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mauna/mauna.dart';

import 'demo_settings.dart';

const double settingsBodyHeight = 340;
const double settingsNavWidth = 140;
const double swatchSize = 16;

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final DemoSettings settings;

  final ValueChanged<DemoSettings> onChanged;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late DemoSettings _settings = widget.settings;
  int _tab = 0;

  void _selectTab(int index) {
    setState(() => _tab = index);
  }

  void _update(DemoSettings settings) {
    setState(() => _settings = settings);
    widget.onChanged(settings);
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return MaunaDialog(
      title: 'Settings',
      child: SizedBox(
        height: settingsBodyHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MaunaSidebar(
              width: settingsNavWidth,
              items: const <String>['Appearance', 'About'],
              selectedIndex: _tab,
              onSelected: _selectTab,
            ),
            Expanded(
              child: ColoredBox(
                color: theme.bgCanvas,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(theme.spacing.md),
                  child: _tab == 0
                      ? _AppearancePanel(
                          settings: _settings,
                          onChanged: _update,
                        )
                      : const _AboutPanel(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppearancePanel extends StatelessWidget {
  const _AppearancePanel({required this.settings, required this.onChanged});

  final DemoSettings settings;

  final ValueChanged<DemoSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool light = theme.brightness == Brightness.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.lg,
      children: <Widget>[
        _Group(
          label: 'Theme',
          child: Row(
            spacing: theme.spacing.xs,
            children: <Widget>[
              for (final DemoPreset preset in DemoPreset.values)
                Expanded(
                  child: _ChoiceTile(
                    selected: settings.preset == preset,
                    onTap: () => onChanged(settings.copyWith(preset: preset)),
                    builder: (bool strong) => Center(
                      child: Text(
                        preset.label,
                        style: theme.uiStyle.copyWith(
                          color: strong
                              ? theme.textPrimary
                              : theme.textSecondary,
                          fontWeight: settings.preset == preset
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        _Group(
          label: 'Accent color',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: theme.spacing.xs,
            children: <Widget>[
              for (int row = 0; row < DemoAccent.presets.length; row += 2)
                Row(
                  spacing: theme.spacing.xs,
                  children: <Widget>[
                    for (final DemoAccent accent in DemoAccent.presets.sublist(
                      row,
                      row + 2,
                    ))
                      Expanded(
                        child: _AccentTile(
                          accent: accent,
                          color: light ? accent.value.light : accent.value.dark,
                          selected: settings.accent.name == accent.name,
                          onTap: () =>
                              onChanged(settings.copyWith(accent: accent)),
                        ),
                      ),
                  ],
                ),
              _CustomAccentField(settings: settings, onChanged: onChanged),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutPanel extends StatelessWidget {
  const _AboutPanel();

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return _Group(
      label: 'Design system',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: theme.spacing.xs,
        children: <Widget>[
          Text('Mauna HIG: interface tokens and rules.', style: theme.uiStyle),
          Text('Package license: Apache 2.0.', style: theme.uiStyle),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.label, required this.child});

  final String label;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.xs,
      children: <Widget>[
        Text(label.toUpperCase(), style: theme.labelStyle),
        child,
      ],
    );
  }
}

class _ChoiceTile extends StatefulWidget {
  const _ChoiceTile({
    required this.selected,
    required this.onTap,
    required this.builder,
  });

  final bool selected;

  final VoidCallback onTap;

  final Widget Function(bool strong) builder;

  @override
  State<_ChoiceTile> createState() => _ChoiceTileState();
}

class _ChoiceTileState extends State<_ChoiceTile> {
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) {
    setState(() => _hovered = value);
  }

  void _setFocused(bool value) {
    setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool strong = widget.selected || _hovered || _focused;
    final Color borderColor = widget.selected
        ? theme.accent
        : (_hovered || _focused)
        ? theme.textSecondary
        : theme.line;
    return Semantics(
      button: true,
      selected: widget.selected,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: _setHovered,
        onShowFocusHighlight: _setFocused,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) => widget.onTap(),
          ),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: theme.motion.fast,
            curve: MaunaMotion.fastCurve,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.sm,
              vertical: theme.metrics.listItemPaddingY,
            ),
            decoration: BoxDecoration(
              color: widget.selected ? theme.bgCanvas : theme.bgChrome,
              border: Border.all(
                color: borderColor,
                width: widget.selected
                    ? theme.metrics.focusRingWidth
                    : theme.metrics.borderWidth,
              ),
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            child: widget.builder(strong),
          ),
        ),
      ),
    );
  }
}

class _AccentTile extends StatelessWidget {
  const _AccentTile({
    required this.accent,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final DemoAccent accent;

  final Color color;

  final bool selected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return _ChoiceTile(
      selected: selected,
      onTap: onTap,
      builder: (bool strong) => Row(
        spacing: theme.spacing.sm,
        children: <Widget>[
          Container(
            width: swatchSize,
            height: swatchSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(theme.radiusLg),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  accent.name,
                  style: theme.captionStyle.copyWith(color: theme.textPrimary),
                ),
                Text(
                  colorToHex(color),
                  style: theme.captionStyle.copyWith(
                    fontFamily: theme.fontDoc,
                    fontFamilyFallback: MaunaFonts.docFallback,
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            MaunaIcon(
              MaunaGlyphs.check(),
              color: theme.accent,
              size: theme.metrics.smallIconSize,
            ),
        ],
      ),
    );
  }
}

class _CustomAccentField extends StatefulWidget {
  const _CustomAccentField({required this.settings, required this.onChanged});

  final DemoSettings settings;

  final ValueChanged<DemoSettings> onChanged;

  @override
  State<_CustomAccentField> createState() => _CustomAccentFieldState();
}

class _CustomAccentFieldState extends State<_CustomAccentField> {
  late final MaunaTextController _hex = MaunaTextController(
    text: widget.settings.accent.name == DemoAccent.customName
        ? colorToHex(widget.settings.accent.value.light)
        : '',
  );
  final FocusNode _focusNode = FocusNode();
  String? _error;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _hex.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _apply() {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final Color? color = parseHex(_hex.text.trim());
    if (color == null) {
      setState(() => _error = 'Enter a color as #RRGGBB.');
      return;
    }
    if (!meetsWcagAa(color, theme.bgCanvas) ||
        !meetsWcagAa(color, theme.bgChrome)) {
      final String direction = theme.brightness == Brightness.light
          ? 'darker'
          : 'lighter';
      setState(
        () => _error =
            'Contrast with the background is too low. Choose a $direction color.',
      );
      return;
    }
    setState(() => _error = null);
    widget.onChanged(
      widget.settings.copyWith(accent: DemoAccent.custom(color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final String? error = _error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing.xs,
      children: <Widget>[
        Text('Custom HEX', style: theme.captionStyle),
        Row(
          spacing: theme.spacing.xs,
          children: <Widget>[
            Expanded(
              child: AnimatedContainer(
                duration: theme.motion.fast,
                curve: MaunaMotion.fastCurve,
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.sm,
                  vertical: theme.spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.bgChrome,
                  border: Border.all(
                    color: _focusNode.hasFocus ? theme.accent : theme.line,
                    width: theme.metrics.borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(theme.radiusSm),
                ),
                child: Stack(
                  children: <Widget>[
                    if (_hex.text.isEmpty)
                      IgnorePointer(
                        child: Text(
                          '#RRGGBB',
                          style: theme.docStyle.copyWith(
                            fontSize: theme.typeScale.ui,
                            height: theme.lineHeightUi,
                            color: theme.textSecondary,
                          ),
                        ),
                      ),
                    EditableText(
                      controller: _hex,
                      focusNode: _focusNode,
                      style: theme.docStyle.copyWith(
                        fontSize: theme.typeScale.ui,
                        height: theme.lineHeightUi,
                      ),
                      cursorColor: theme.accent,
                      backgroundCursorColor: theme.textSecondary,
                      cursorWidth: theme.metrics.cursorWidth,
                      selectionColor: theme.selectionColor,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onChanged: (String value) => setState(() {}),
                      onSubmitted: (String value) => _apply(),
                    ),
                  ],
                ),
              ),
            ),
            _ApplyButton(onPressed: _apply),
          ],
        ),
        if (error != null) Text(error, style: theme.captionStyle),
      ],
    );
  }
}

class _ApplyButton extends StatefulWidget {
  const _ApplyButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends State<_ApplyButton> {
  bool _focused = false;

  void _setFocused(bool value) {
    setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Semantics(
      button: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: _setFocused,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) => widget.onPressed(),
          ),
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.accent,
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            foregroundDecoration: _focused
                ? BoxDecoration(
                    border: Border.all(
                      color: theme.textPrimary,
                      width: theme.metrics.focusRingWidth,
                    ),
                    borderRadius: BorderRadius.circular(theme.radiusSm),
                  )
                : null,
            child: Text(
              'Apply',
              style: theme.uiStyle.copyWith(color: theme.textOnAccent),
            ),
          ),
        ),
      ),
    );
  }
}
