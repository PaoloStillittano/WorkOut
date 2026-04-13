import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _useSystemTheme = false;

  ThemeMode get themeMode => _themeMode;
  bool get useSystemTheme => _useSystemTheme;

  ThemeProvider() {
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme = prefs.getBool(AppConstants.keyUseSystemTheme) ?? false;
    final savedThemeMode = prefs.getString(AppConstants.keyThemeMode) ?? 'dark';
    _themeMode = savedThemeMode == 'light' ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AppConstants.keyThemeMode, mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setUseSystemTheme(bool value) async {
    _useSystemTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyUseSystemTheme, value);
    notifyListeners();
  }
}
