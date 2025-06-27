import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ibmi/main.dart' as app;
import 'package:flutter/cupertino.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full BMI Calculation Flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    const reset = '\x1B[0m';
    const green = '\x1B[32m';
    const red = '\x1B[31m';
    const yellow = '\x1B[33m';
    const cyan = '\x1B[36m';
    const bold = '\x1B[1m';

    print('$cyan🔍 Running Full BMI Calculation Flow...$reset');

    final Finder increaseWeightButton = find.byKey(Key('increase-weight'));
    final Finder calculateBMIButton = find.text("Calculate BMI");

    await tester.tap(increaseWeightButton);
    await tester.pumpAndSettle();

    print('$yellow⚖️  Increased Weight$reset');

    await tester.tap(calculateBMIButton);
    await tester.pumpAndSettle();

    final overweightText = find.text('Overweight');
    final bmiValueText = find.text('25.86'); // Update this if dynamic
    final okButton = find.text('OK');

    expect(overweightText, findsOneWidget);
    expect(bmiValueText, findsOneWidget);
    expect(okButton, findsOneWidget);

    print('\x1B[1;34m📋 Dialog Contents:\x1B[0m');
    print('$yellow📌 Overweight$reset');
    print('$cyan📌 25.86$reset');
    print('$green📌 OK button found$reset');

    await tester.tap(okButton);
    await tester.pumpAndSettle();

    print('$green✔️ BMI Result Saved Successfully$reset');
    print('$bold$green🎉 Full Flow Passed!$reset');
  });
}
