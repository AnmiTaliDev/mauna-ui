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
    expect(tester.getSize(find.byType(MaunaSidebar)).width, 200);

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
