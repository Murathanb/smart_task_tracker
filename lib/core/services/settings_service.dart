import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  ThemeMode getThemeMode() {
    final value = _prefs.getString(AppConstants.themeKey) ?? 'system';
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
      case ThemeMode.dark:
        value = 'dark';
      default:
        value = 'system';
    }
    await _prefs.setString(AppConstants.themeKey, value);
  }

  Locale getLocale() {
    final code = _prefs.getString(AppConstants.languageKey) ?? 'tr';
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(AppConstants.languageKey, locale.languageCode);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(AppConstants.notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(AppConstants.notificationsKey, value);
  }
}