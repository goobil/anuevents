import 'package:flutter/services.dart';

class FlutterLocalNotificationsPlugin {
  static const MethodChannel _channel = MethodChannel('dexterous/flutter_local_notifications');

  Future<void> initialize(Object? settings) async {
    await _channel.invokeMethod('initialize', {});
  }

  Future<void> zonedSchedule(int id, String? title, String? body, int epochMs, Map<String, dynamic> args) async {
    await _channel.invokeMethod('zonedSchedule', {
      'id': id,
      'title': title,
      'body': body,
      'epochMs': epochMs,
      'payload': args['payload'],
    });
  }

  Future<void> cancel(int id) async {
    await _channel.invokeMethod('cancel', {'id': id});
  }
}

class AndroidInitializationSettings {
  final String icon;
  const AndroidInitializationSettings(this.icon);
}

class DarwinInitializationSettings {
  final bool requestSoundPermission;
  final bool requestBadgePermission;
  final bool requestAlertPermission;
  const DarwinInitializationSettings({this.requestSoundPermission = true, this.requestBadgePermission = true, this.requestAlertPermission = true});
}

class InitializationSettings {
  final AndroidInitializationSettings? android;
  final DarwinInitializationSettings? iOS;
  InitializationSettings({this.android, this.iOS});
}

class AndroidNotificationDetails {
  final String channelId;
  final String channelName;
  final String? channelDescription;
  final int importance;
  final int priority;
  AndroidNotificationDetails(this.channelId, this.channelName, {this.channelDescription, this.importance = 4, this.priority = 2});
}

class DarwinNotificationDetails {}

class NotificationDetails {
  final AndroidNotificationDetails? android;
  final DarwinNotificationDetails? iOS;
  NotificationDetails({this.android, this.iOS});
}

class UILocalNotificationDateInterpretation {
  static const absoluteTime = 0;
}

class Importance {
  static const int max = 4;
}

class Priority {
  static const int high = 2;
}
