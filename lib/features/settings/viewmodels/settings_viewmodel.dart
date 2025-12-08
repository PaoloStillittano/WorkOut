import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class SettingsViewModel extends ChangeNotifier {
  int _totalSets = 5;
  int _seriesPerSet = 4;
  int _repsPerSeries = 10;
  int _restTimeSeconds = 90;

  int get totalSets => _totalSets;
  int get seriesPerSet => _seriesPerSet;
  int get repsPerSeries => _repsPerSeries;
  int get restTimeSeconds => _restTimeSeconds;

  SettingsViewModel() {
    loadConfig();
  }

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _totalSets = prefs.getInt(AppConstants.keyTotalSets) ?? 5;
    _seriesPerSet = prefs.getInt(AppConstants.keySeriesPerSet) ?? 4;
    _repsPerSeries = prefs.getInt(AppConstants.keyRepsPerSeries) ?? 10;
    _restTimeSeconds = prefs.getInt(AppConstants.keyRestTime) ?? 90;
    notifyListeners();
  }

  Future<void> saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyTotalSets, _totalSets);
    await prefs.setInt(AppConstants.keySeriesPerSet, _seriesPerSet);
    await prefs.setInt(AppConstants.keyRepsPerSeries, _repsPerSeries);
    await prefs.setInt(AppConstants.keyRestTime, _restTimeSeconds);
    notifyListeners();
  }

  void updateTotalSets(int value) {
    _totalSets = value;
    notifyListeners();
  }

  void updateSeriesPerSet(int value) {
    _seriesPerSet = value;
    notifyListeners();
  }

  void updateRepsPerSeries(int value) {
    _repsPerSeries = value;
    notifyListeners();
  }

  void updateRestTimeSeconds(int value) {
    _restTimeSeconds = value;
    notifyListeners();
  }
}
