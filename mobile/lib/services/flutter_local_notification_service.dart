import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart';

class FlutterLocalNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  int _idFromString(String id) {
    // convert id to a stable int for the plugin. Keep within 32-bit range.
    return id.hashCode & 0x7fffffff;
  }

  @override
  Future<void> scheduleReminder({required String id, required DateTime at, required String title, String? body}) async {
    await initialize();
    final scheduleEpoch = at.toUtc().millisecondsSinceEpoch;
    // Platform-specific details are handled on the native side by the
    // vendored plugin. We only send a minimal payload (epoch + ids + text).
    await _plugin.zonedSchedule(
      _idFromString(id),
      title,
      body,
      scheduleEpoch,
      {
        'payload': null,
        'android': {
          'channelId': 'anuevents_reminders',
        }
      },
    );
  }

  @override
  Future<void> cancelReminder(String id) async {
    await _plugin.cancel(_idFromString(id));
  }
}
