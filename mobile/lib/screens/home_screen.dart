import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _fs = FirestoreService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ANU Events')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search events',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          // category chips placeholder
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: const [
                Chip(label: Text('All')),
                SizedBox(width: 8),
                Chip(label: Text('Music')),
                SizedBox(width: 8),
                Chip(label: Text('Community')),
                SizedBox(width: 8),
                Chip(label: Text('Sports')),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _fs.streamApprovedEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final events = snapshot.data ?? [];
                final filtered = _query.isEmpty
                    ? events
                    : events
                        .where((e) => e.title.toLowerCase().contains(_query.toLowerCase()))
                        .toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No events found'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => EventCard(event: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
