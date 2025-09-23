import 'package:flutter_test/flutter_test.dart';
import 'package:anuevents_mobile/models/user_profile.dart';

void main() {
  test('UserProfile.fromDoc parses travelInterests', () {
    final data = {
      'prefs': {'travelInterests': ['hiking', 'music']}
    };

    final profile = UserProfile.fromData(id: 'user123', data: data);

    expect(profile.id, 'user123');
    expect(profile.travelInterests, isA<List<String>>());
    expect(profile.travelInterests, containsAll(['hiking', 'music']));
  });

  test('UserProfile.fromDoc handles missing prefs gracefully', () {
    final profile = UserProfile.fromData(id: 'user456', data: {});
    expect(profile.id, 'user456');
    expect(profile.travelInterests, isEmpty);
  });
}
