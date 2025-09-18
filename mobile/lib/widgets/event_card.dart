import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/bookmarks_provider.dart';
// ...existing code...

class EventCard extends ConsumerWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = DateFormat.yMMMd().add_jm();
    final user = ref.watch(currentUserProvider);
    final savedIdsAsync = user == null ? const AsyncValue.data(<String>{}) : ref.watch(bookmarksProvider(user.uid));
    final isSaved = savedIdsAsync.asData?.value.contains(event.id) ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(event.title),
        subtitle: Text('${df.format(event.startsAt)} • ${event.location}'),
        onTap: () {},
        trailing: IconButton(
          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
          onPressed: user == null
              ? null
              : () async {
                  await ref.read(bookmarksServiceProvider).toggleSaveEvent(user.uid, event.id);
                },
        ),
      ),
    );
  }
}
