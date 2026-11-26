import 'package:flutter/widgets.dart';
import 'package:mauna/mauna.dart';

import 'demo_settings.dart';

const double settingsBodyHeight = 340;
const double settingsNavWidth = 140;
const double swatchSize = 14;

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
        MaunaFormSection(
          title: 'Theme',
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(theme.spacing.sm),
              child: MaunaSegmentedControl<DemoPreset>(
                segments: <DemoPreset, String>{
                  for (final DemoPreset preset in DemoPreset.values)
                    preset: preset.label,
                },
                selected: settings.preset,
                onChanged: (DemoPreset preset) =>
                    onChanged(settings.copyWith(preset: preset)),
              ),
            ),
          ],
        ),
        MaunaFormSection(
          title: 'Accent color',
          children: <Widget>[
            for (final DemoAccent accent in DemoAccent.presets)
              MaunaFormRow(
                label: accent.name,
                description: colorToHex(
                  light ? accent.value.light : accent.value.dark,
                ),
                control: settings.accent.name == accent.name
                    ? MaunaIcon(MaunaGlyphs.check(), color: theme.accent)
                    : MaunaButton(
                        label: 'Use',
                        onPressed: () =>
                            onChanged(settings.copyWith(accent: accent)),
                      ),
              ),
            _CustomAccentField(settings: settings, onChanged: onChanged),
          ],
        ),
      ],
    );
  }
}

class _AboutPanel extends StatelessWidget {
  const _AboutPanel();

  @override
  Widget build(BuildContext context) {
    return const MaunaFormSection(
      title: 'Design system',
      children: <Widget>[
        MaunaFormRow(
          label: 'Mauna HIG',
          description: 'Interface tokens and rules.',
        ),
        MaunaFormRow(label: 'Package license', description: 'Apache 2.0.'),
      ],
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
  late final TextEditingController _hex = TextEditingController(
    text: widget.settings.accent.name == DemoAccent.customName
        ? colorToHex(widget.settings.accent.value.light)
        : '',
  );
  final FocusNode _focusNode = FocusNode();
  String? _error;

  @override
  void dispose() {
    _hex.dispose();
    _focusNode.dispose();
    super.dispose();
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
    return MaunaFormRow(
      label: 'Custom HEX',
      description: _error,
      below: Row(
        spacing: MaunaThemeData.of(context).spacing.sm,
        children: <Widget>[
          Expanded(
            child: MaunaTextField(
              controller: _hex,
              focusNode: _focusNode,
              placeholder: '#RRGGBB',
              onSubmitted: (String value) => _apply(),
            ),
          ),
          MaunaButton(label: 'Apply', onPressed: _apply, prominent: true),
        ],
      ),
    );
  }
}
