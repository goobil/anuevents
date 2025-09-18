

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream approved events for feed
  Stream<List<Event>> streamApprovedEvents({int limit = 50}) {
    return _db
        .collection('events')
        .where('status', isEqualTo: 'approved')
        .orderBy('startsAt')
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Event.fromFirestore(d)).toList());
  }

  // Submit a new event (saves with status 'pending')
  Future<DocumentReference> createEvent(Map<String, dynamic> payload) async {
    payload['status'] = 'pending';
    payload['createdAt'] = FieldValue.serverTimestamp();
    final ref = await _db.collection('events').add(payload);
    return ref;
  }

  // Update event (used by moderators to approve/reject)
  Future<void> updateEvent(String id, Map<String, dynamic> updates) async {
    updates['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection('events').doc(id).update(updates);
  }

  // Get event by id
  Future<Event?> getEventById(String id) async {
    final doc = await _db.collection('events').doc(id).get();
    if (!doc.exists) return null;
    return Event.fromFirestore(doc);
  }

  // Toggle save/bookmark for a user
  Future<void> toggleSaveEvent(String userId, String eventId) async {
    final ref = _db.collection('users').doc(userId).collection('saved').doc(eventId);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.delete();
    } else {
      await ref.set({'savedAt': FieldValue.serverTimestamp()});
    }
  }

  // Stream saved events for a user
  Stream<List<Event>> streamSavedEventsForUser(String userId) {
    final savedRef = _db.collection('users').doc(userId).collection('saved').orderBy('savedAt');
    return savedRef.snapshots().asyncMap((snap) async {
      final ids = snap.docs.map((d) => d.id).toList();
      if (ids.isEmpty) return <Event>[];
      final eventsSnap = await _db.collection('events').where(FieldPath.documentId, whereIn: ids).get();
      return eventsSnap.docs.map((d) => Event.fromFirestore(d)).toList();
    });
  }

  // Stream saved event IDs for a user (lightweight for UI toggles)
  Stream<Set<String>> streamSavedEventIdsForUser(String userId) {
    final savedRef = _db.collection('users').doc(userId).collection('saved').orderBy('savedAt');
    return savedRef.snapshots().map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  // Stream pending moderation events
  Stream<List<Event>> streamPendingModeration({int limit = 100}) {
    return _db
        .collection('events')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Event.fromFirestore(d)).toList());
  }

  // Simple search by title (client-side friendly)
  Future<List<Event>> searchByTitle(String q, {int limit = 20}) async {
    if (q.isEmpty) return [];
    final snap = await _db
        .collection('events')
        .where('status', isEqualTo: 'approved')
        .orderBy('title')
        .startAt([q]).endAt(['$q\uf8ff']).limit(limit)
        .get();
    return snap.docs.map((d) => Event.fromFirestore(d)).toList();
  }

  // placeholder for poster upload metadata handling
  Future<void> attachPoster(String eventId, Map<String, dynamic> posterMeta) async {
    await _db.collection('events').doc(eventId).update({'poster': posterMeta});
  }

  // Save user interests (tags) to users/{userId}.prefs.travelInterests
  Future<void> saveUserInterests(String userId, List<String> interests) async {
    await _db.collection('users').doc(userId).set({
      'prefs': {
        'travelInterests': interests,
      }
    }, SetOptions(merge: true));
  }

  // Stream user document for profile consumption
  Stream<DocumentSnapshot> userDocStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }
}

