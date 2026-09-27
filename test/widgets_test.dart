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
            children: <Widget>[
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
          children: <Widget>[
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
    expect(tester.getSize(find.byType(MaunaIcon)), const Size.square(18));
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
    expect(tester.getSize(find.byType(MaunaSidebar)).width, 184);

    await tester.pumpWidget(sidebar(true));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MaunaSidebar)).width, 0);
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
      _app(const MaunaStatusBar(items: <String>['Words: 12', 'Page 1'])),
    );
    expect(tester.getSize(find.byType(MaunaStatusBar)).height, 28);
    expect(find.text('Words: 12'), findsOneWidget);
  });

  testWidgets('document canvas draws the accent caret and blinks', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: 'Text',
    );
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

  testWidgets('document column is capped at 620px', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final TextEditingController controller = TextEditingController();
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
                  MaunaCommand(label: 'Save', onSelected: () => ran = 'save'),
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

    await tester.enterText(find.byType(EditableText), 'op');
    await tester.pump();
    expect(find.text('Save'), findsNothing);

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(ran, 'open');
    expect(find.byType(MaunaCommandPalette), findsNothing);
  });
}
