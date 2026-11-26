import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mauna/mauna.dart';

Widget _app(Widget child) {
  return MaterialApp(
    theme: MaunaThemeData.light().toMaterialTheme(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('toolbar is 40px and hides in focus mode', (
    WidgetTester tester,
  ) async {
    Widget toolbar(bool hidden) => _app(
      Column(
        children: <Widget>[
          MaunaToolbar(
            hidden: hidden,
            leading: <Widget>[
              MaunaToolbarButton(label: 'Save', onPressed: () {}),
            ],
          ),
        ],
      ),
    );

    await tester.pumpWidget(toolbar(false));
    expect(tester.getSize(find.byType(MaunaToolbar)).height, 40);
    expect(find.text('Save'), findsOneWidget);

    await tester.pumpWidget(toolbar(true));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MaunaToolbar)).height, 0);
  });

  testWidgets('toolbar button falls back to label and fires', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _app(
        MaunaToolbar(
          leading: <Widget>[
            MaunaToolbarButton(label: 'Save', onPressed: () => taps++),
            MaunaToolbarButton(
              icon: MaunaGlyphs.search(),
              label: 'Find',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Save'));
    expect(taps, 1);
    expect(find.byType(MaunaIcon), findsOneWidget);
    expect(tester.getSize(find.byType(MaunaIcon)), const Size.square(16));
    expect(find.text('Find'), findsNothing);
  });

  testWidgets('sidebar collapses to zero width', (WidgetTester tester) async {
    Widget sidebar(bool collapsed) => _app(
      Row(
        children: <Widget>[
          MaunaSidebar(
            items: const <String>['Prologue', 'Chapter 1'],
            selectedIndex: 0,
            onSelected: (int index) {},
            collapsed: collapsed,
          ),
        ],
      ),
    );

    await tester.pumpWidget(sidebar(false));
    expect(tester.getSize(find.byType(MaunaSidebar)).width, 200);

    await tester.pumpWidget(sidebar(true));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MaunaSidebar)).width, 0);
  });

  testWidgets('sidebar scrolls to the selected item', (
    WidgetTester tester,
  ) async {
    Widget sidebar(int selected) => _app(
      Row(
        children: <Widget>[
          MaunaSidebar(
            items: <String>[for (int i = 0; i < 80; i++) 'Scene $i'],
            selectedIndex: selected,
            onSelected: (int index) {},
          ),
        ],
      ),
    );
    final Rect screen = const Rect.fromLTWH(0, 0, 800, 600);

    await tester.pumpWidget(sidebar(0));
    await tester.pumpAndSettle();
    expect(screen.contains(tester.getCenter(find.text('Scene 70'))), isFalse);

    await tester.pumpWidget(sidebar(70));
    await tester.pumpAndSettle();
    expect(screen.contains(tester.getCenter(find.text('Scene 70'))), isTrue);
  });

  testWidgets('sidebar reports a drag onto an allowed item', (
    WidgetTester tester,
  ) async {
    final List<(int, int)> moves = <(int, int)>[];
    await tester.pumpWidget(
      _app(
        Row(
          children: <Widget>[
            MaunaSidebar(
              items: const <String>['One', 'Two', 'Three'],
              selectedIndex: 0,
              onSelected: (int index) {},
              onReorder: (int from, int to) => moves.add((from, to)),
              canReorder: (int from, int to) => to != 2,
            ),
          ],
        ),
      ),
    );
    Future<void> drag(String from, String to) async {
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.text(from)),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(0, 24));
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text(to).first));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
    }

    await drag('One', 'Two');
    await drag('One', 'Three');
    expect(moves, <(int, int)>[(0, 1)]);
  });

  testWidgets('sidebar items work from the keyboard', (
    WidgetTester tester,
  ) async {
    int? picked;
    await tester.pumpWidget(
      _app(
        Row(
          children: <Widget>[
            MaunaSidebar(
              items: const <String>['Prologue', 'Chapter 1'],
              selectedIndex: 0,
              onSelected: (int index) => picked = index,
            ),
          ],
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(picked, 1);
  });

  testWidgets('status bar is 28px', (WidgetTester tester) async {
    await tester.pumpWidget(
      _app(const MaunaStatusBar(leading: <String>['Words: 12', 'Page 1'])),
    );
    expect(tester.getSize(find.byType(MaunaStatusBar)).height, 28);
    expect(find.text('Words: 12'), findsOneWidget);
    expect(find.text('|'), findsOneWidget);
  });

  testWidgets('selected text uses textOnAccent', (WidgetTester tester) async {
    final MaunaTextController controller = MaunaTextController(text: 'one two');
    addTearDown(controller.dispose);
    controller.selection = const TextSelection(baseOffset: 4, extentOffset: 7);
    late TextSpan span;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (BuildContext context) {
            span = controller.buildTextSpan(
              context: context,
              withComposing: false,
            );
            return const SizedBox();
          },
        ),
      ),
    );
    final TextSpan selected = span.children![1] as TextSpan;
    expect(selected.text, 'two');
    expect(selected.style!.color, MaunaLightColors.textOnAccent);
  });

  testWidgets('button, switch and segmented control report input', (
    WidgetTester tester,
  ) async {
    final List<Object> events = <Object>[];
    await tester.pumpWidget(
      _app(
        Column(
          children: <Widget>[
            MaunaButton(label: 'Done', onPressed: () => events.add('done')),
            const MaunaButton(label: 'Off', onPressed: null),
            MaunaSwitch(label: 'Autosave', value: false, onChanged: events.add),
            SizedBox(
              width: 200,
              child: MaunaSegmentedControl<int>(
                segments: const <int, String>{1: 'One', 2: 'Two'},
                selected: 1,
                onChanged: events.add,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Done'));
    await tester.tap(find.text('Off'));
    await tester.tap(find.byType(MaunaSwitch));
    await tester.tap(find.text('Two'));
    expect(events, <Object>['done', true, 2]);
  });

  testWidgets('button works from the keyboard', (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _app(MaunaButton(label: 'Done', onPressed: () => taps++)),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 1);
  });

  testWidgets('markup styles titles and hides markers off the caret line', (
    WidgetTester tester,
  ) async {
    final MaunaTextController controller = MaunaTextController(
      text: '# Title\n\nSome **bold** and `code`.',
      markup: true,
    );
    addTearDown(controller.dispose);
    controller.selection = const TextSelection.collapsed(offset: 0);
    late TextSpan onTitle;
    late TextSpan offTitle;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (BuildContext context) {
            onTitle = controller.buildTextSpan(
              context: context,
              withComposing: false,
            );
            return const SizedBox();
          },
        ),
      ),
    );
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (BuildContext context) {
            offTitle = controller.buildTextSpan(
              context: context,
              withComposing: false,
            );
            return const SizedBox();
          },
        ),
      ),
    );
    final MaunaThemeData theme = MaunaThemeData.light();
    TextSpan child(TextSpan span, String text) => span.children!
        .cast<TextSpan>()
        .firstWhere((TextSpan s) => s.text == text);

    expect(child(onTitle, 'Title').style!.fontSize, theme.typeScale.title);
    expect(child(onTitle, '# ').style!.color, theme.textSecondary);
    expect(child(offTitle, '# ').style!.color!.a, 0);
    expect(child(offTitle, 'bold').style!.fontWeight, FontWeight.w700);
    expect(child(offTitle, 'code').style!.backgroundColor, theme.bgChrome);
    expect(controller.titleLines().single, const TextRange(start: 0, end: 7));
  });

  testWidgets('restore button brings the toolbar back', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _app(Center(child: MaunaToolbarRestoreButton(onPressed: () => taps++))),
    );
    expect(tester.getSize(find.byType(MaunaToolbarRestoreButton)).width, 24);
    await tester.tap(find.byType(MaunaToolbarRestoreButton));
    expect(taps, 1);
  });

  testWidgets('dialog shows a title and closes', (WidgetTester tester) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (BuildContext context) => GestureDetector(
            onTap: () => showMaunaDialog<void>(
              context: context,
              builder: (BuildContext context) => const MaunaDialog(
                title: 'Settings',
                child: SizedBox(height: 100),
              ),
            ),
            child: const Text('show'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.byType(MaunaToolbarButton));
    await tester.pumpAndSettle();
    expect(find.byType(MaunaDialog), findsNothing);
  });

  testWidgets('document canvas draws the accent caret and blinks', (
    WidgetTester tester,
  ) async {
    final MaunaTextController controller = MaunaTextController(text: 'Text');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(MaunaDocumentCanvas(controller: controller, autofocus: true)),
    );
    await tester.pump();
    await tester.pump();

    Finder caret() => find.byWidgetPredicate(
      (Widget widget) =>
          widget is ColoredBox && widget.color == MaunaLightColors.accent,
    );
    expect(caret(), findsOneWidget);
    expect(tester.getSize(caret()).width, 2);

    await tester.pump(const Duration(milliseconds: 530));
    expect(caret(), findsNothing);
    await tester.pump(const Duration(milliseconds: 530));
    expect(caret(), findsOneWidget);
  });

  testWidgets('document canvas opens a context menu on right click', (
    WidgetTester tester,
  ) async {
    final MaunaTextController controller = MaunaTextController(text: 'Text');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(
        MaunaDocumentCanvas(
          controller: controller,
          autofocus: true,
          contextMenuLabels: const MaunaContextMenuLabels(selectAll: 'All'),
        ),
      ),
    );
    await tester.pump();

    await tester.tapAt(
      tester.getCenter(find.byType(EditableText)),
      buttons: kSecondaryButton,
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(
      controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 4),
    );
  });

  testWidgets('document column is capped at 620px', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final MaunaTextController controller = MaunaTextController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(
        MaunaDocumentCanvas(
          controller: controller,
          placeholder: 'Start writing',
        ),
      ),
    );
    expect(tester.getSize(find.byType(EditableText)).width, 620);
    expect(find.text('Start writing'), findsOneWidget);
  });

  testWidgets('command palette scrolls with the arrow keys', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: MaunaCommandPalette(
            commands: <MaunaCommand>[
              for (int i = 0; i < 40; i++)
                MaunaCommand(label: 'Command $i', onSelected: () {}),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    final Rect list = tester.getRect(find.byType(SingleChildScrollView));
    bool inList(String label) =>
        list.contains(tester.getCenter(find.text(label)));

    for (int i = 0; i < 20; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
    }
    expect(inList('Command 20'), isTrue);
    expect(inList('Command 0'), isFalse);

    for (int i = 0; i < 21; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();
    }
    expect(inList('Command 39'), isTrue);
  });

  testWidgets('command palette ranks fuzzy matches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: MaunaCommandPalette(
            commands: <MaunaCommand>[
              for (final String label in <String>[
                'Export to PDF',
                'Open settings',
                'Open',
                'Reopen',
              ])
                MaunaCommand(label: label, onSelected: () {}),
            ],
          ),
        ),
      ),
    );
    double top(String label) => tester.getTopLeft(find.text(label)).dy;

    await tester.enterText(find.byType(EditableText), 'open');
    await tester.pump();
    expect(top('Open settings'), lessThan(top('Open')));
    expect(top('Open'), lessThan(top('Reopen')));
    expect(find.text('Export to PDF'), findsNothing);

    await tester.enterText(find.byType(EditableText), 'exp pdf');
    await tester.pump();
    expect(find.text('Export to PDF'), findsOneWidget);
    expect(find.text('Open'), findsNothing);
  });

  testWidgets('command palette filters and runs a command', (
    WidgetTester tester,
  ) async {
    String? ran;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (BuildContext context) => GestureDetector(
            onTap: () => showMaunaPopup<void>(
              context: context,
              builder: (BuildContext context) => MaunaCommandPalette(
                commands: <MaunaCommand>[
                  MaunaCommand(
                    label: 'Save',
                    shortcut: 'Ctrl+S',
                    onSelected: () => ran = 'save',
                  ),
                  MaunaCommand(label: 'Open', onSelected: () => ran = 'open'),
                ],
              ),
            ),
            child: const Text('show'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a command'), findsOneWidget);
    expect(find.text('Ctrl+S'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'op');
    await tester.pump();
    expect(find.text('Save'), findsNothing);

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(ran, 'open');
    expect(find.byType(MaunaCommandPalette), findsNothing);
  });
}
