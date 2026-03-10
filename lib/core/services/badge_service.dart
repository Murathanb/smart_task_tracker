import 'package:flutter_app_badger/flutter_app_badger.dart';

class BadgeService {
  static final BadgeService _instance = BadgeService._();
  factory BadgeService() => _instance;
  BadgeService._();

  Future<void> updateBadge(int count) async {
    if (count > 0) {
      FlutterAppBadger.updateBadgeCount(count);
    } else {
      FlutterAppBadger.removeBadge();
    }
  }

  Future<void> clearBadge() async {
    FlutterAppBadger.removeBadge();
  }
}