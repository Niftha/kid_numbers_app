import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kids_numbers_app/main.dart';

void main() {
  testWidgets('HomeScreen loads correctly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(LearnNumbersApp());

    // Check AppBar title
    expect(find.text('Learn Numbers'), findsOneWidget);

    // Check at least number “1” exists on HomeScreen
    expect(find.text('1'), findsWidgets);

    // Check at least number “One” exists
    expect(find.text('One'), findsWidgets);
  });
}
