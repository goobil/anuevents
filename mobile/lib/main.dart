import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/auth_provider.dart';
import 'services/firebase_storage_service.dart';

// Note: native Firebase configuration files were placed by FlutterFire CLI.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(overrides: [
    storageServiceProvider.overrideWithValue(FirebaseStorageService()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ANU Events',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, ref, _) {
          final authState = ref.watch(authStateProvider);
          return authState.when(
            data: (user) => user == null ? const AuthScreen() : const HomeScreen(),
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (e, st) => Scaffold(body: Center(child: Text('Auth init error: $e'))),
          );
        },
      ),
    );
  }
}
