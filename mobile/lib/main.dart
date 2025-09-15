import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Note: you must provide native Firebase configuration files for Android (google-services.json)
// and iOS (GoogleService-Info.plist) in the respective platform folders before running.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANU Events'),
      ),
      body: const Center(child: Text('Home feed scaffold - Firebase initialized')),
    );
  }
}
