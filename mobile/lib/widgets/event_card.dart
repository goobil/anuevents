import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(event.title),
        subtitle: Text('${df.format(event.startsAt)} • ${event.location}'),
        onTap: () {},
      ),
    );
  }
}
