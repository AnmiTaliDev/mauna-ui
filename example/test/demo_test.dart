import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mauna/mauna.dart';
import 'package:mauna_example/main.dart';

void main() {
  testWidgets('demo lists headings and toggles focus mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaunaDemoApp());
    await tester.pump();

    expect(find.text('Principles'), findsOneWidget);
    expect(find.text('Voice and tone'), findsWidgets);
    expect(find.textContaining('Words: '), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.getSize(find.byType(MaunaToolbar)).height, 0);
    expect(tester.getSize(find.byType(MaunaSidebar)).width, 0);
  });
}
