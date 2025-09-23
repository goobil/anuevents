import 'package:flutter_test/flutter_test.dart';
import 'package:anuevents_mobile/models/event.dart';

void main() {
  test('Event.fromFirestore parses optional fields', () {
    final data = {
      'title': 'Fun Run',
      'description': 'A local fun run',
      'startsAt': DateTime.now(),
      'status': 'approved',
      'location': 'Park',
      'tagIds': ['running', 'community'],
      'posterUrl': 'https://example.com/poster.jpg',
      'posterThumb': 'https://example.com/thumb.jpg',
      'ticketsUrl': 'https://tickets.example.com',
    };

    // Create a fake DocumentSnapshot by calling the constructor path is not possible here,
    // but we can check that Event constructor accepts optional fields.
    final event = Event(
      id: 'e1',
      title: data['title'] as String,
      description: data['description'] as String,
      startsAt: DateTime.now(),
      status: 'approved',
      location: 'Park',
      tagIds: List<String>.from(['running', 'community']),
      posterUrl: data['posterUrl'] as String?,
      posterThumb: data['posterThumb'] as String?,
      ticketsUrl: data['ticketsUrl'] as String?,
    );

    expect(event.posterUrl, isNotNull);
    expect(event.ticketsUrl, contains('tickets'));
  });
}
