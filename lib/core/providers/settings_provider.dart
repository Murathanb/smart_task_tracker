import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/settings_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsService(prefs);
});

// Theme
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SettingsService _service;

  ThemeNotifier(this._service) : super(_service.getThemeMode());

  Future<void> setTheme(ThemeMode mode) async {
    await _service.setThemeMode(mode);
    state = mode;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(settingsServiceProvider));
});

// Locale
class LocaleNotifier extends StateNotifier<Locale> {
  final SettingsService _service;

  LocaleNotifier(this._service) : super(_service.getLocale());

  Future<void> setLocale(Locale locale) async {
    await _service.setLocale(locale);
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(settingsServiceProvider));
});

// Notifications
class NotificationsNotifier extends StateNotifier<bool> {
  final SettingsService _service;

  NotificationsNotifier(this._service)
      : super(_service.getNotificationsEnabled());

  Future<void> toggle(bool value) async {
    await _service.setNotificationsEnabled(value);
    state = value;
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  return NotificationsNotifier(ref.watch(settingsServiceProvider));
});