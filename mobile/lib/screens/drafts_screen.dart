import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import 'submit_event_screen.dart';

class DraftsScreen extends ConsumerWidget {
  const DraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Scaffold(body: Center(child: Text('Please sign in')));

  final stream = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('drafts').orderBy('updatedAt', descending: true).snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Drafts')),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('No drafts found'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data() as Map<String, dynamic>? ?? {};
              final title = data['title'] ?? '(untitled)';
              return ListTile(
                title: Text(title),
                subtitle: Text('Updated: ${data['updatedAt'] ?? ''}'),
                trailing: TextButton(
                  child: const Text('Load'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SubmitEventScreen(draftId: d.id, draftData: data)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
