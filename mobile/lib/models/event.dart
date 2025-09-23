import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startsAt;
  final String status;
  final String location;
  final List<String> tagIds;
  // Optional enriched fields for details and lists
  final String? posterUrl; // full-size poster
  final String? posterThumb; // small thumbnail
  final String? ticketsUrl;
  final String? organizerName;
  final String? venueName;
  final double? latitude;
  final double? longitude;
  final String? categoryName;
  final String? priceTier; // e.g. free, $, $$

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startsAt,
    required this.status,
    required this.location,
    required this.tagIds,
    this.posterUrl,
    this.posterThumb,
    this.ticketsUrl,
    this.organizerName,
    this.venueName,
    this.latitude,
    this.longitude,
    this.categoryName,
    this.priceTier,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Event(
      id: doc.id,
      title: data["title"] ?? '',
      description: data["description"] ?? '',
      startsAt: (data["startsAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data["status"] ?? 'pending',
      location: data["location"] ?? '',
      tagIds: List<String>.from(data["tagIds"] ?? []),
      posterUrl: data['posterUrl'] as String?,
      posterThumb: data['posterThumb'] as String?,
      ticketsUrl: data['ticketsUrl'] as String?,
      organizerName: data['organizerName'] as String?,
      venueName: data['venueName'] as String?,
      latitude: (data['lat'] as num?)?.toDouble(),
      longitude: (data['lng'] as num?)?.toDouble(),
      categoryName: data['categoryName'] as String?,
      priceTier: data['priceTier'] as String?,
    );
  }
}
