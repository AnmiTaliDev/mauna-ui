import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mauna/mauna.dart';

import 'demo_settings.dart';
import 'sample_document.dart';
import 'settings_dialog.dart';

void main() {
  runApp(const MaunaDemoApp());
}

const double brandNameSize = 15;
const double brandNameLetterSpacing = -0.2;
const double brandTagSize = 11;
const int wordsPerPage = 250;
const String initialCaretAfter = 'not a widget tree.';

class MaunaDemoApp extends StatefulWidget {
  const MaunaDemoApp({super.key});

  @override
  State<MaunaDemoApp> createState() => _MaunaDemoAppState();
}

class _MaunaDemoAppState extends State<MaunaDemoApp> {
  DemoSettings _settings = DemoSettings(
    preset: DemoPreset.paper,
    accent: DemoAccent.presets.first,
  );

  MaunaThemeData _lightTheme() {
    final Color accent = _settings.accent.value.light;
    if (_settings.preset == DemoPreset.sepia) {
      return MaunaThemeData.sepia(accent: accent);
    }
    return MaunaThemeData.light(accent: accent);
  }

  MaunaThemeData _darkTheme() {
    final Color accent = _settings.accent.value.dark;
    if (_settings.preset == DemoPreset.midnight) {
      return MaunaThemeData.midnight(accent: accent);
    }
    return MaunaThemeData.dark(accent: accent);
  }

  ThemeMode _themeMode() {
    switch (_settings.preset) {
      case DemoPreset.paper:
      case DemoPreset.sepia:
        return ThemeMode.light;
      case DemoPreset.ink:
      case DemoPreset.midnight:
        return ThemeMode.dark;
      case DemoPreset.system:
        return ThemeMode.system;
    }
  }

  void _setSettings(DemoSettings settings) {
    setState(() => _settings = settings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mauna',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme().toMaterialTheme(),
      darkTheme: _darkTheme().toMaterialTheme(),
      themeMode: _themeMode(),
      home: EditorScreen(settings: _settings, onSettingsChanged: _setSettings),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  final DemoSettings settings;

  final ValueChanged<DemoSettings> onSettingsChanged;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final MaunaTextController _document = MaunaTextController(
    text: sampleDocument,
    markup: true,
  );
  final FocusNode _documentFocus = FocusNode();
  String _lastText = sampleDocument;
  bool _focusMode = false;
  bool _sidebarOpen = true;
  bool _writing = false;

  @override
  void initState() {
    super.initState();
    _document.selection = TextSelection.collapsed(
      offset:
          sampleDocument.indexOf(initialCaretAfter) + initialCaretAfter.length,
    );
    _document.addListener(_onDocumentChanged);
    _documentFocus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _document.dispose();
    _documentFocus.dispose();
    super.dispose();
  }

  void _onDocumentChanged() {
    final bool edited = _document.text != _lastText;
    _lastText = _document.text;
    setState(() => _writing = _writing || edited);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _onPointerMoved(PointerHoverEvent event) {
    if (_writing) {
      setState(() => _writing = false);
    }
  }

  List<TextRange> _sections() {
    return _document.titleLines();
  }

  String _sectionTitle(TextRange range) {
    return range
        .textInside(_document.text)
        .substring(MaunaTextController.titleMarker.length);
  }

  int? _currentSection(List<TextRange> sections) {
    final int caret = _document.selection.baseOffset;
    int? current;
    for (int i = 0; i < sections.length; i++) {
      if (sections[i].start <= caret) {
        current = i;
      }
    }
    return current;
  }

  int _wordCount() {
    return _document.text
        .split(RegExp(r'\s+'))
        .where((String word) => RegExp(r'[A-Za-z0-9]').hasMatch(word))
        .length;
  }

  void _jumpToSection(int index) {
    final TextRange section = _sections()[index];
    final int paragraph = _document.text.indexOf('\n\n', section.end);
    final int offset = paragraph == -1 ? section.end : paragraph + 2;
    _document.selection = TextSelection.collapsed(offset: offset);
    _documentFocus.requestFocus();
  }

  void _toggleSidebar() {
    setState(() => _sidebarOpen = !_sidebarOpen);
  }

  void _toggleFocusMode() {
    setState(() => _focusMode = !_focusMode);
    _documentFocus.requestFocus();
  }

  void _exitFocusMode() {
    if (_focusMode) {
      _toggleFocusMode();
    }
  }

  void _setPreset(DemoPreset preset) {
    widget.onSettingsChanged(widget.settings.copyWith(preset: preset));
  }

  void _setAccent(DemoAccent accent) {
    widget.onSettingsChanged(widget.settings.copyWith(accent: accent));
  }

  Future<void> _openPalette() async {
    await showMaunaPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          MaunaCommandPalette(commands: _commands()),
    );
    _documentFocus.requestFocus();
  }

  Future<void> _openSettings() async {
    await showMaunaDialog<void>(
      context: context,
      builder: (BuildContext context) => SettingsDialog(
        settings: widget.settings,
        onChanged: widget.onSettingsChanged,
      ),
    );
    _documentFocus.requestFocus();
  }

  List<MaunaCommand> _commands() {
    final List<TextRange> sections = _sections();
    return <MaunaCommand>[
      for (int i = 0; i < sections.length; i++)
        MaunaCommand(
          label: 'Go to ${_sectionTitle(sections[i])}',
          onSelected: () => _jumpToSection(i),
        ),
      MaunaCommand(
        label: _sidebarOpen ? 'Hide sidebar' : 'Show sidebar',
        onSelected: _toggleSidebar,
      ),
      MaunaCommand(
        label: _focusMode ? 'Exit focus mode' : 'Enter focus mode',
        onSelected: _toggleFocusMode,
      ),
      MaunaCommand(label: 'Open settings', onSelected: _openSettings),
      for (final DemoPreset preset in DemoPreset.values)
        MaunaCommand(
          label: 'Use ${preset.label} theme',
          onSelected: () => _setPreset(preset),
        ),
      for (final DemoAccent accent in DemoAccent.presets)
        MaunaCommand(
          label: 'Use ${accent.name.toLowerCase()} accent',
          onSelected: () => _setAccent(accent),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool dimmed = _writing && _documentFocus.hasFocus;
    final List<TextRange> sections = _sections();
    final int? current = _currentSection(sections);
    final int words = _wordCount();

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _openPalette,
        const SingleActivator(LogicalKeyboardKey.keyB, control: true):
            _toggleSidebar,
        const SingleActivator(LogicalKeyboardKey.comma, control: true):
            _openSettings,
        const SingleActivator(
          LogicalKeyboardKey.keyF,
          control: true,
          shift: true,
        ): _toggleFocusMode,
        const SingleActivator(LogicalKeyboardKey.escape): _exitFocusMode,
      },
      child: MouseRegion(
        onHover: _onPointerMoved,
        child: ColoredBox(
          color: theme.bgCanvas,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  MaunaToolbar(
                    hidden: _focusMode,
                    dimmed: dimmed,
                    leading: <Widget>[
                      MaunaToolbarButton(
                        icon: MaunaGlyphs.menu(),
                        label: _sidebarOpen ? 'Hide sidebar' : 'Show sidebar',
                        onPressed: _toggleSidebar,
                      ),
                      const _Brand(),
                    ],
                    trailing: <Widget>[
                      MaunaToolbarButton(
                        label: 'Commands',
                        onPressed: _openPalette,
                      ),
                      MaunaToolbarButton(
                        icon: MaunaGlyphs.focus(),
                        label: 'Enter focus mode',
                        onPressed: _toggleFocusMode,
                      ),
                      MaunaToolbarChip(
                        icon: MaunaGlyphs.settings(),
                        label: 'Settings',
                        onPressed: _openSettings,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        MaunaSidebar(
                          title: 'Sections',
                          items: <String>[
                            for (final TextRange section in sections)
                              _sectionTitle(section),
                          ],
                          selectedIndex: current,
                          onSelected: _jumpToSection,
                          collapsed: _focusMode || !_sidebarOpen,
                          dimmed: dimmed,
                        ),
                        Expanded(
                          child: MaunaDocumentCanvas(
                            controller: _document,
                            focusNode: _documentFocus,
                            placeholder: 'Start writing',
                            autofocus: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaunaStatusBar(
                    dimmed: dimmed,
                    leading: <String>[
                      '${theme.fontDoc} ${theme.typeScale.doc.round()}px',
                      'Words: $words',
                    ],
                    trailing: <String>[
                      if (current != null)
                        _sectionTitle(sections[current])
                      else
                        'Page ${words ~/ wordsPerPage + 1}',
                    ],
                  ),
                ],
              ),
              if (_focusMode)
                Positioned(
                  top: theme.spacing.xs,
                  right: theme.spacing.xs,
                  child: MaunaToolbarRestoreButton(onPressed: _exitFocusMode),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      spacing: theme.spacing.xs,
      children: <Widget>[
        Text(
          'Mauna',
          style: theme.uiStyle.copyWith(
            fontSize: brandNameSize,
            fontWeight: FontWeight.w500,
            letterSpacing: brandNameLetterSpacing,
          ),
        ),
        Text(
          'editor',
          style: theme.captionStyle.copyWith(
            fontSize: brandTagSize,
            fontFamily: theme.fontDoc,
            fontFamilyFallback: MaunaFonts.docFallback,
          ),
        ),
      ],
    );
  }
}
