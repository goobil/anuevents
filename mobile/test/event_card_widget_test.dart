import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anuevents_mobile/widgets/event_card.dart';
import 'package:anuevents_mobile/models/event.dart';
import 'package:anuevents_mobile/providers/bookmarks_provider.dart';
import 'package:anuevents_mobile/providers/auth_provider.dart';
import 'package:anuevents_mobile/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _FakeUser implements User {
  @override
  final String uid;

  _FakeUser(this.uid);

  // Unused members
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeService extends FirestoreService {
  bool toggled = false;
  String? lastUser;
  String? lastEvent;

  @override
  Future<void> toggleSaveEvent(String userId, String eventId) async {
    toggled = !toggled;
    lastUser = userId;
    lastEvent = eventId;
  }
}

void main() {
  testWidgets('EventCard bookmark toggle calls FirestoreService.toggleSaveEvent', (tester) async {
    final fakeService = _FakeService();
    final fakeUser = _FakeUser('userX');
    final event = Event(
      id: 'event1',
      title: 'Test',
      description: '',
      startsAt: DateTime.now(),
      status: 'approved',
      location: 'Nowhere',
      tagIds: [],
    );

    await tester.pumpWidget(ProviderScope(overrides: [
      bookmarksServiceProvider.overrideWithValue(fakeService),
      // bookmarksProvider family instance override for userX
      bookmarksProvider('userX').overrideWithValue(const AsyncValue.data(<String>{})),
      currentUserProvider.overrideWithValue(fakeUser),
    ], child: MaterialApp(home: Scaffold(body: EventCard(event: event)))));

    await tester.pumpAndSettle();

    final bookmarkButton = find.byIcon(Icons.bookmark_border);
    expect(bookmarkButton, findsOneWidget);

    await tester.tap(bookmarkButton);
    await tester.pumpAndSettle();

    expect(fakeService.toggled, isTrue);
    expect(fakeService.lastUser, 'userX');
    expect(fakeService.lastEvent, 'event1');
  });
}
