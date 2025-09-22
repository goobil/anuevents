

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class FirestoreService {
  FirebaseFirestore? _db;
  FirebaseFirestore get _firestore => _db ??= FirebaseFirestore.instance;

  // Stream approved events for feed
  Stream<List<Event>> streamApprovedEvents({int limit = 50}) {
  return _firestore
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
    // createdAt should be set server-side (Cloud Function / Firestore serverTimestamp) to
    // avoid clients mixing FieldValue objects into plain string maps. Firestore rules
    // and server code should apply the timestamp when creating documents.
    try {
      final ref = await _firestore.collection('events').add(payload);
      // Debug: log created document id to help troubleshooting during manual tests
      // ignore: avoid_print
      print('FirestoreService.createEvent: created event ${ref.id}');
      return ref;
    } catch (e) {
      // ignore: avoid_print
      print('FirestoreService.createEvent: failed to create event: $e');
      rethrow;
    }
  }

  // Alias to create a draft/pending event with same semantics
  Future<DocumentReference> createDraftEvent(Map<String, dynamic> payload) async {
    return createEvent(payload);
  }

  // Update event (used by moderators to approve/reject)
  Future<void> updateEvent(String id, Map<String, dynamic> updates) async {
    updates['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('events').doc(id).update(updates);
  }

  // Get event by id
  Future<Event?> getEventById(String id) async {
    final doc = await _firestore.collection('events').doc(id).get();
    if (!doc.exists) return null;
    return Event.fromFirestore(doc);
  }

  // Toggle save/bookmark for a user
  Future<void> toggleSaveEvent(String userId, String eventId) async {
    final ref = _firestore.collection('users').doc(userId).collection('saved').doc(eventId);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.delete();
    } else {
      await ref.set({'savedAt': FieldValue.serverTimestamp()});
    }
  }

  // Stream saved events for a user
  Stream<List<Event>> streamSavedEventsForUser(String userId) {
    final savedRef = _firestore.collection('users').doc(userId).collection('saved').orderBy('savedAt');
    return savedRef.snapshots().asyncMap((snap) async {
      final ids = snap.docs.map((d) => d.id).toList();
      if (ids.isEmpty) return <Event>[];
      final eventsSnap = await _firestore.collection('events').where(FieldPath.documentId, whereIn: ids).get();
      return eventsSnap.docs.map((d) => Event.fromFirestore(d)).toList();
    });
  }

  // Stream saved event IDs for a user (lightweight for UI toggles)
  Stream<Set<String>> streamSavedEventIdsForUser(String userId) {
    final savedRef = _firestore.collection('users').doc(userId).collection('saved').orderBy('savedAt');
    return savedRef.snapshots().map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  // Stream pending moderation events
  Stream<List<Event>> streamPendingModeration({int limit = 100}) {
  return _firestore
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
  final snap = await _firestore
        .collection('events')
        .where('status', isEqualTo: 'approved')
        .orderBy('title')
        .startAt([q]).endAt(['$q\uf8ff']).limit(limit)
        .get();
    return snap.docs.map((d) => Event.fromFirestore(d)).toList();
  }

  // placeholder for poster upload metadata handling
  Future<void> attachPoster(String eventId, Map<String, dynamic> posterMeta) async {
    await _firestore.collection('events').doc(eventId).update({'poster': posterMeta});
  }

  // Save user interests (tags) to users/{userId}.prefs.travelInterests
  Future<void> saveUserInterests(String userId, List<String> interests) async {
    // Also persist that onboarding was completed when interests are saved.
    await _firestore.collection('users').doc(userId).set({
      'prefs': {
        'travelInterests': interests,
        'onboardingCompleted': true,
      }
    }, SetOptions(merge: true));
  }

  // Stream user document for profile consumption
  Stream<DocumentSnapshot> userDocStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}

