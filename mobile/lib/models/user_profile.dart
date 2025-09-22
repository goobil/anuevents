import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final List<String> travelInterests;

  UserProfile({required this.id, required this.travelInterests});

  factory UserProfile.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final prefs = data['prefs'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      id: doc.id,
      travelInterests: List<String>.from(prefs['travelInterests'] ?? []),
    );
  }
}
