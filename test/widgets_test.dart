import 'package:flutter/material.dart';
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
              MaunaToolbarButton(label: 'Сохранить', onPressed: () {}),
            ],
          ),
        ],
      ),
    );

    await tester.pumpWidget(toolbar(false));
    expect(tester.getSize(find.byType(MaunaToolbar)).height, 40);
    expect(find.text('Сохранить'), findsOneWidget);

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
            MaunaToolbarButton(label: 'Сохранить', onPressed: () => taps++),
            MaunaToolbarButton(
              icon: Icons.search_outlined,
              label: 'Найти',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Сохранить'));
    expect(taps, 1);
    expect(find.byIcon(Icons.search_outlined), findsOneWidget);
    expect(find.text('Найти'), findsNothing);
  });

  testWidgets('sidebar collapses to zero width', (WidgetTester tester) async {
    Widget sidebar(bool collapsed) => _app(
      Row(
        children: <Widget>[
          MaunaSidebar(
            items: const <String>['Пролог', 'Глава 1'],
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

  testWidgets('status bar is 28px', (WidgetTester tester) async {
    await tester.pumpWidget(
      _app(const MaunaStatusBar(items: <String>['Слов: 12', 'Страница 1'])),
    );
    expect(tester.getSize(find.byType(MaunaStatusBar)).height, 28);
    expect(find.text('Слов: 12'), findsOneWidget);
  });

  testWidgets('document canvas draws the accent caret and blinks', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: 'Текст',
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
          placeholder: 'Начните писать',
        ),
      ),
    );
    expect(tester.getSize(find.byType(EditableText)).width, 620);
    expect(find.text('Начните писать'), findsOneWidget);
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
                    label: 'Сохранить',
                    onSelected: () => ran = 'save',
                  ),
                  MaunaCommand(
                    label: 'Открыть',
                    onSelected: () => ran = 'open',
                  ),
                ],
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Введите команду'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'откр');
    await tester.pump();
    expect(find.text('Сохранить'), findsNothing);

    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();
    expect(ran, 'open');
    expect(find.byType(MaunaCommandPalette), findsNothing);
  });
}
