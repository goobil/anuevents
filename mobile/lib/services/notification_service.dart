abstract class NotificationService {
  Future<void> initialize();
  Future<void> scheduleReminder({required String id, required DateTime at, required String title, String? body});
  Future<void> cancelReminder(String id);
}

// A no-op implementation useful for tests and initial app runs.
class NoopNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> scheduleReminder({required String id, required DateTime at, required String title, String? body}) async {}

  @override
  Future<void> cancelReminder(String id) async {}
}
