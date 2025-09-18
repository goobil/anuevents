import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../widgets/event_card.dart';
import '../providers/auth_provider.dart';
import 'account_screen.dart';
import 'onboarding_interests_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final FirestoreService _fs = FirestoreService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ANU Events'), actions: [
        PopupMenuButton<String>(
          onSelected: (v) async {
            if (v == 'account') {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountScreen()));
            } else if (v == 'signout') {
              await ref.read(authServiceProvider).signOut();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'account', child: Text('Account')),
            PopupMenuItem(value: 'signout', child: Text('Sign out')),
          ],
        )
      ]),
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
                // fetch user interests and compute simple client-side recommendations
                final user = ref.watch(currentUserProvider);
                List<String> interests = [];
                if (user != null) {
                  final profile = ref.watch(userProfileProvider(user.uid)).asData?.value;
                  interests = profile?.travelInterests ?? [];
                }
                // score events by tag intersection with interests
                List eventsScored = events.map((e) {
                  final tags = (e.tagIds).cast<String>();
                  final score = tags.where((t) => interests.contains(t)).length;
                  return {'event': e, 'score': score};
                }).toList();
                eventsScored.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
                final scoredEvents = eventsScored.map((s) => s['event'] as dynamic).toList();
                final displayList = _query.isEmpty ? scoredEvents : scoredEvents.where((e) => (e.title as String).toLowerCase().contains(_query.toLowerCase())).toList();
                final filtered = _query.isEmpty
                    ? events
                    : events
                        .where((e) => e.title.toLowerCase().contains(_query.toLowerCase()))
                        .toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No events found'));
                }
                return ListView.builder(
                  itemCount: displayList.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      // Recommended strip
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Recommended for you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                TextButton(
                                  onPressed: () async {
                                    final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnboardingInterestsScreen()));
                                    if (res == true) setState(() {});
                                  },
                                  child: const Text('Edit'),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 140,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: displayList.take(10).map((e) => SizedBox(width: 260, child: EventCard(event: e))).toList(),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    final ev = displayList[i - 1];
                    return EventCard(event: ev);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
