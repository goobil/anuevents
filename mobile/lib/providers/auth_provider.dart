import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  final svc = ref.watch(authServiceProvider);
  return svc.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.asData?.value;
});

// Stream user profile document
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final userProfileProvider = StreamProvider.autoDispose.family<DocumentSnapshot?, String>((ref, uid) {
  if (uid.isEmpty) return const Stream.empty();
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
});
