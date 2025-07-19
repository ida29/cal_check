import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calorie_checker_ai/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CalorieCheckerApp(),
      ),
    );

    // Verify that the app launches without errors
    expect(find.text('Calorie Checker AI'), findsOneWidget);
    expect(find.text('Today\'s Summary'), findsOneWidget);
    expect(find.text('Add Meal'), findsOneWidget);
  });

  testWidgets('Navigation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CalorieCheckerApp(),
      ),
    );

    // Tap on the History tab
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    // Should navigate to history screen (would need to verify content)
    // This is a basic test that ensures navigation doesn't crash

    // Tap on the Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Should navigate to settings screen
  });

  testWidgets('FloatingActionButton navigates to camera', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CalorieCheckerApp(),
      ),
    );

    // Find the floating action button
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    // Tap it (camera screen navigation would be tested separately)
    await tester.tap(fab);
    await tester.pumpAndSettle();
  });
}