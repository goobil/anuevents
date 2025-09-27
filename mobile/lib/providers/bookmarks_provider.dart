import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';

final bookmarksServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

/// Stream of bookmarked event IDs for a given user
final bookmarksProvider = StreamProvider.family<Set<String>, String>((ref, uid) {
  if (uid.isEmpty) return const Stream.empty();
  final svc = ref.read(bookmarksServiceProvider);
  return svc.streamSavedEventIdsForUser(uid);
});
