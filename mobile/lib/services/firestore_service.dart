import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Event>> streamApprovedEvents({int limit = 50}) {
    return _db
        .collection('events')
        .where('status', isEqualTo: 'approved')
        .orderBy('startsAt')
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Event.fromFirestore(d)).toList());
  }

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
}
