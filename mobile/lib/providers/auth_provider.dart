import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

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

// Notification service provider (default noop, override in app or tests)
final notificationServiceProvider = Provider<NotificationService>((ref) => NoopNotificationService());

// Storage service provider (mock by default; override with Firebase-backed impl later)
final storageServiceProvider = Provider<StorageService>((ref) => MockStorageService());

final userProfileProvider = StreamProvider.autoDispose.family<UserProfile?, String>((ref, uid) {
  if (uid.isEmpty) return const Stream.empty();
  final firestore = ref.read(firestoreServiceProvider);
  final stream = firestore.userDocStream(uid);
  return stream.map((snap) => UserProfile.fromDoc(snap));
});
