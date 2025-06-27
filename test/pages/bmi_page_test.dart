import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ibmi/pages/bmi_page.dart';

void main() {
  testWidgets('Weight select widget increments and decrements correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(720, 1600)),
        child: CupertinoApp(home: BMIPage()),
      ),
    );

    await tester.pumpAndSettle();

    // Check initial value
    expect(find.text('72'), findsOneWidget);

    // Tap weight '+' button
    await tester.tap(find.byKey(Key('increase-weight')));
    await tester.pump();

    expect(find.text('73'), findsOneWidget);

    // Tap weight '-' button
    await tester.tap(find.byKey(Key('decrease-weight')));
    await tester.pump();

    expect(find.text('72'), findsOneWidget);
  });
}
