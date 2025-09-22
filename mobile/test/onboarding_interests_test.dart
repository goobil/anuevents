import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anuevents_mobile/screens/onboarding_interests_screen.dart';
import 'package:anuevents_mobile/providers/auth_provider.dart';

void main() {
  testWidgets('onboarding screen renders and has disabled save when not signed in', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: OnboardingInterestsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // The chips are rendered
    expect(find.text('music'), findsOneWidget);

    // Save button rendered but disabled because no user is provided
    final saveButton = find.text('Save interests');
    expect(saveButton, findsOneWidget);
    final elevated = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(elevated.onPressed, isNull);
  });
}
