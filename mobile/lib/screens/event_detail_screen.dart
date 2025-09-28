import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../providers/auth_provider.dart';
import '../providers/bookmarks_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
// notification service provided via provider

class EventDetailScreen extends ConsumerWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = DateFormat.yMMMMd().add_jm();
  final user = ref.watch(currentUserProvider);
    final savedIdsAsync = user == null
        ? const AsyncValue.data(<String>{})
        : ref.watch(bookmarksProvider(user.uid));
    final isSaved = savedIdsAsync.asData?.value.contains(event.id) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: user == null
                ? null
                : () async {
                    await ref.read(bookmarksServiceProvider).toggleSaveEvent(user.uid, event.id);
                  },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Placeholder: integrate share_plus later
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share coming soon')));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          if (event.posterUrl != null && event.posterUrl!.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(event.posterUrl!, fit: BoxFit.cover),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 18),
                    const SizedBox(width: 6),
                    Text(df.format(event.startsAt)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.place, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(event.venueName ?? event.location)),
                  ],
                ),
                if (event.organizerName != null) ...[
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.account_circle, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(event.organizerName!)),
                  ]),
                ],
                const SizedBox(height: 16),
                Text(event.description),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (event.ticketsUrl != null && event.ticketsUrl!.isNotEmpty)
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.local_activity),
                          label: const Text('Tickets'),
                          onPressed: () async {
                            final uri = Uri.parse(event.ticketsUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(isSaved ? Icons.bookmark_added : Icons.bookmark_add_outlined),
                        label: Text(isSaved ? 'Saved' : 'Save'),
                        onPressed: user == null
                            ? null
                            : () async {
                                await ref.read(bookmarksServiceProvider).toggleSaveEvent(user.uid, event.id);
                                // schedule a default reminder 24h prior to start
                                final notif = ref.read(notificationServiceProvider);
                                if (event.startsAt.isAfter(DateTime.now())) {
                                  final at = event.startsAt.subtract(const Duration(hours: 24));
                                  await notif.scheduleReminder(id: event.id, at: at, title: event.title, body: event.venueName ?? event.location);
                                }
                              },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
