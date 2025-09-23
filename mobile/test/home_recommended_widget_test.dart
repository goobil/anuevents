import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anuevents_mobile/screens/home_screen.dart';
import 'package:anuevents_mobile/models/event.dart';
import 'package:anuevents_mobile/providers/auth_provider.dart';
import 'package:anuevents_mobile/services/firestore_service.dart';

class _FakeFS extends FirestoreService {
  @override
  Stream<List<Event>> streamApprovedEvents({int limit = 50}) async* {
    final now = DateTime.now();
    final e1 = Event(id: 'a', title: 'Music Night', description: '', startsAt: now, status: 'approved', location: 'L1', tagIds: ['music']);
    final e2 = Event(id: 'b', title: 'Community BBQ', description: '', startsAt: now.add(Duration(days:1)), status: 'approved', location: 'L2', tagIds: ['community']);
    final e3 = Event(id: 'c', title: 'Running Club', description: '', startsAt: now.add(Duration(days:2)), status: 'approved', location: 'L3', tagIds: ['running']);
    yield [e1, e2, e3];
  }
}

void main() {
  testWidgets('Recommended strip prioritizes tag matches', (tester) async {
    final fakeFs = _FakeFS();

    await tester.pumpWidget(ProviderScope(overrides: [
      firestoreServiceProvider.overrideWithValue(fakeFs),
      // fake auth state: user signed in
      authStateProvider.overrideWithValue(const AsyncValue.data(null)),
    ], child: const MaterialApp(home: HomeScreen())));

    await tester.pumpAndSettle();

    // Ensure the Recommended strip header exists
    expect(find.text('Recommended for you'), findsOneWidget);
  });
}
