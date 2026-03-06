import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BadgeService {
  static final BadgeService _instance = BadgeService._();
  factory BadgeService() => _instance;
  BadgeService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> updateBadge(int count) async {
    await _plugin.show(
      0,
      null,
      null,
      NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: true,
          presentSound: false,
          badgeNumber: count,
        ),
      ),
    );
  }

  Future<void> clearBadge() async {
    await updateBadge(0);
  }
}