import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startsAt;
  final String status;
  final String location;
  final List<String> tagIds;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startsAt,
    required this.status,
    required this.location,
    required this.tagIds,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startsAt: (data['startsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'pending',
      location: data['location'] ?? '',
      tagIds: List<String>.from(data['tagIds'] ?? []),
    );
  }
}
