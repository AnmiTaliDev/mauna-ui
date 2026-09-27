import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mauna/mauna.dart';

void main() {
  runApp(const MaunaDemoApp());
}

enum DemoPreset { paper, sepia, ink, midnight }

const String sampleText = '''# Prologue

The last tram left the depot at a quarter past midnight.

# Chapter 1

Morning came slowly over the harbor. The ferry was late again.

# Chapter 2

Nobody at the station remembered the man in the grey coat.
''';

class MaunaDemoApp extends StatefulWidget {
  const MaunaDemoApp({super.key});

  @override
  State<MaunaDemoApp> createState() => _MaunaDemoAppState();
}

class _MaunaDemoAppState extends State<MaunaDemoApp> {
  DemoPreset _preset = DemoPreset.paper;
  MaunaAccent _accent = MaunaAccents.steelBlue;

  MaunaThemeData _buildTheme() {
    switch (_preset) {
      case DemoPreset.paper:
        return MaunaThemeData.light(accent: _accent.light);
      case DemoPreset.sepia:
        return MaunaThemeData.sepia(accent: _accent.light);
      case DemoPreset.ink:
        return MaunaThemeData.dark(accent: _accent.dark);
      case DemoPreset.midnight:
        return MaunaThemeData.midnight(accent: _accent.dark);
    }
  }

  void _setPreset(DemoPreset preset) {
    setState(() => _preset = preset);
  }

  void _setAccent(MaunaAccent accent) {
    setState(() => _accent = accent);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mauna',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme().toMaterialTheme(),
      home: EditorScreen(
        preset: _preset,
        onPresetChanged: _setPreset,
        onAccentChanged: _setAccent,
      ),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    super.key,
    required this.preset,
    required this.onPresetChanged,
    required this.onAccentChanged,
  });

  final DemoPreset preset;
  final ValueChanged<DemoPreset> onPresetChanged;
  final ValueChanged<MaunaAccent> onAccentChanged;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _document = TextEditingController(
    text: sampleText,
  );
  final FocusNode _documentFocus = FocusNode();
  bool _focusMode = false;
  bool _sidebarOpen = true;
  bool _chromeHovered = false;
  int? _selectedHeading;

  @override
  void initState() {
    super.initState();
    _document.addListener(_onDocumentChanged);
    _documentFocus.addListener(_onDocumentChanged);
  }

  @override
  void dispose() {
    _document.dispose();
    _documentFocus.dispose();
    super.dispose();
  }

  void _onDocumentChanged() {
    setState(() {});
  }

  List<int> _headingOffsets() {
    final List<int> offsets = <int>[];
    int offset = 0;
    for (final String line in _document.text.split('\n')) {
      if (line.startsWith('# ')) {
        offsets.add(offset);
      }
      offset += line.length + 1;
    }
    return offsets;
  }

  List<String> _headingTitles() {
    return <String>[
      for (final String line in _document.text.split('\n'))
        if (line.startsWith('# ')) line.substring(2),
    ];
  }

  int _wordCount() {
    return _document.text
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty && word != '#')
        .length;
  }

  void _jumpToHeading(int index) {
    final int offset = _headingOffsets()[index];
    setState(() => _selectedHeading = index);
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

  void _toggleBrightness() {
    switch (widget.preset) {
      case DemoPreset.paper:
        widget.onPresetChanged(DemoPreset.ink);
      case DemoPreset.sepia:
        widget.onPresetChanged(DemoPreset.midnight);
      case DemoPreset.ink:
        widget.onPresetChanged(DemoPreset.paper);
      case DemoPreset.midnight:
        widget.onPresetChanged(DemoPreset.sepia);
    }
  }

  void _setChromeHovered(bool value) {
    setState(() => _chromeHovered = value);
  }

  Future<void> _openPalette() async {
    await showMaunaPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          MaunaCommandPalette(commands: _commands()),
    );
    _documentFocus.requestFocus();
  }

  List<MaunaCommand> _commands() {
    return <MaunaCommand>[
      MaunaCommand(
        label: _sidebarOpen ? 'Hide sidebar' : 'Show sidebar',
        onSelected: _toggleSidebar,
      ),
      MaunaCommand(
        label: _focusMode ? 'Exit focus mode' : 'Enter focus mode',
        onSelected: _toggleFocusMode,
      ),
      MaunaCommand(
        label: 'Use Paper theme',
        onSelected: () => widget.onPresetChanged(DemoPreset.paper),
      ),
      MaunaCommand(
        label: 'Use Sepia theme',
        onSelected: () => widget.onPresetChanged(DemoPreset.sepia),
      ),
      MaunaCommand(
        label: 'Use Ink theme',
        onSelected: () => widget.onPresetChanged(DemoPreset.ink),
      ),
      MaunaCommand(
        label: 'Use Midnight theme',
        onSelected: () => widget.onPresetChanged(DemoPreset.midnight),
      ),
      MaunaCommand(
        label: 'Use steel blue accent',
        onSelected: () => widget.onAccentChanged(MaunaAccents.steelBlue),
      ),
      MaunaCommand(
        label: 'Use graphite accent',
        onSelected: () => widget.onAccentChanged(MaunaAccents.graphite),
      ),
      MaunaCommand(
        label: 'Use cool teal accent',
        onSelected: () => widget.onAccentChanged(MaunaAccents.coolTeal),
      ),
      MaunaCommand(
        label: 'Use indigo accent',
        onSelected: () => widget.onAccentChanged(MaunaAccents.indigo),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MaunaThemeData theme = MaunaThemeData.of(context);
    final bool dimmed = _documentFocus.hasFocus && !_chromeHovered;
    final bool isLight = theme.brightness == Brightness.light;
    final int words = _wordCount();

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _openPalette,
        const SingleActivator(LogicalKeyboardKey.keyB, control: true):
            _toggleSidebar,
        const SingleActivator(
          LogicalKeyboardKey.keyF,
          control: true,
          shift: true,
        ): _toggleFocusMode,
        const SingleActivator(LogicalKeyboardKey.escape): _exitFocusMode,
      },
      child: ColoredBox(
        color: theme.bgCanvas,
        child: Column(
          children: <Widget>[
            MouseRegion(
              onEnter: (PointerEnterEvent event) => _setChromeHovered(true),
              onExit: (PointerExitEvent event) => _setChromeHovered(false),
              child: MaunaToolbar(
                hidden: _focusMode,
                dimmed: dimmed,
                children: <Widget>[
                  MaunaToolbarButton(
                    icon: MaunaGlyphs.sidebar(),
                    label: _sidebarOpen ? 'Hide sidebar' : 'Show sidebar',
                    onPressed: _toggleSidebar,
                  ),
                  MaunaToolbarButton(
                    icon: MaunaGlyphs.command(),
                    label: 'Open commands',
                    onPressed: _openPalette,
                  ),
                  const Spacer(),
                  MaunaToolbarButton(
                    icon: isLight ? MaunaGlyphs.moon() : MaunaGlyphs.sun(),
                    label: isLight ? 'Use dark theme' : 'Use light theme',
                    onPressed: _toggleBrightness,
                  ),
                  MaunaToolbarButton(
                    icon: MaunaGlyphs.focus(),
                    label: 'Enter focus mode',
                    onPressed: _toggleFocusMode,
                    accent: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MouseRegion(
                    onEnter: (PointerEnterEvent event) =>
                        _setChromeHovered(true),
                    onExit: (PointerExitEvent event) =>
                        _setChromeHovered(false),
                    child: MaunaSidebar(
                      items: _headingTitles(),
                      selectedIndex: _selectedHeading,
                      onSelected: _jumpToHeading,
                      collapsed: _focusMode || !_sidebarOpen,
                      dimmed: dimmed,
                    ),
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
              items: <String>['Words: $words', 'Page ${words ~/ 250 + 1}'],
            ),
          ],
        ),
      ),
    );
  }
}
