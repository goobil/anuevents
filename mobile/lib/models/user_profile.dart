import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final List<String> travelInterests;
  final bool onboardingCompleted;

  UserProfile({required this.id, required this.travelInterests, this.onboardingCompleted = false});

  factory UserProfile.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfile.fromData(id: doc.id, data: data);
  }

  factory UserProfile.fromData({required String id, required Map<String, dynamic> data}) {
    final prefs = data['prefs'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      id: id,
      travelInterests: List<String>.from(prefs['travelInterests'] ?? []),
      onboardingCompleted: prefs['onboardingCompleted'] == true,
    );
  }
}
