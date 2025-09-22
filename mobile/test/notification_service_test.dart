import 'package:flutter_test/flutter_test.dart';
import 'package:anuevents_mobile/services/notification_service.dart';

class _FakeNotif extends NoopNotificationService {
  final List<Map<String, dynamic>> scheduled = [];

  @override
  Future<void> scheduleReminder({required String id, required DateTime at, required String title, String? body}) async {
    scheduled.add({'id': id, 'at': at, 'title': title, 'body': body});
  }

  @override
  Future<void> cancelReminder(String id) async {
    scheduled.removeWhere((e) => e['id'] == id);
  }
}

void main() {
  test('schedules and cancels reminders', () async {
    final fake = _FakeNotif();
    await fake.initialize();
    await fake.scheduleReminder(id: 'e1', at: DateTime.now().add(const Duration(hours: 1)), title: 'T', body: 'B');
    expect(fake.scheduled.length, 1);
    await fake.cancelReminder('e1');
    expect(fake.scheduled.length, 0);
  });
}
