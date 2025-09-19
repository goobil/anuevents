import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anuevents_mobile/models/user_profile.dart';

// Minimal fake DocumentSnapshot for testing
class _FakeDoc implements DocumentSnapshot {
  @override
  final String id;
  final Map<String, dynamic>? _data;

  _FakeDoc(this.id, this._data);

  @override
  dynamic data() => _data;

  // The rest of DocumentSnapshot methods are not used in tests.
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('UserProfile.fromDoc parses travelInterests', () {
    final doc = _FakeDoc('user123', {
      'prefs': {'travelInterests': ['hiking', 'music']}
    });

    final profile = UserProfile.fromDoc(doc);

    expect(profile.id, 'user123');
    expect(profile.travelInterests, isA<List<String>>());
    expect(profile.travelInterests, containsAll(['hiking', 'music']));
  });

  test('UserProfile.fromDoc handles missing prefs gracefully', () {
    final doc = _FakeDoc('user456', {});
    final profile = UserProfile.fromDoc(doc);
    expect(profile.id, 'user456');
    expect(profile.travelInterests, isEmpty);
  });
}
