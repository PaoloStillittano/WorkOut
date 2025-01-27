import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _keyThemeMode = 'themeMode';
  static const String _keyUseSystemTheme = 'useSystemTheme';

  late ThemeMode _themeMode;
  late bool _useSystemTheme;

  ThemeMode get themeMode => _themeMode;
  bool get useSystemTheme => _useSystemTheme;

  ThemeController() {
    _themeMode = ThemeMode.light;
    _useSystemTheme = true;
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme = prefs.getBool(_keyUseSystemTheme) ?? true;
    final savedThemeMode = prefs.getString(_keyThemeMode) ?? 'light';
    _themeMode = savedThemeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyThemeMode, mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setUseSystemTheme(bool value) async {
    _useSystemTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseSystemTheme, value);
    notifyListeners();
  }
}
