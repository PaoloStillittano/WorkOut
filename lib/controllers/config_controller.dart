import 'package:shared_preferences/shared_preferences.dart';

class ConfigController {
  static const String _keyTotalSets = 'totalSets';
  static const String _keySeriesPerSet = 'seriesPerSet';
  static const String _keyRepsPerSeries = 'repsPerSeries';
  static const String _keyRestTime = 'restTime';

  int totalSets = 5;
  int seriesPerSet = 4;
  int repsPerSeries = 10;
  int restTimeSeconds = 90;

  ConfigController() {
    loadConfig();
  }

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    totalSets = prefs.getInt(_keyTotalSets) ?? 5;
    seriesPerSet = prefs.getInt(_keySeriesPerSet) ?? 4;
    repsPerSeries = prefs.getInt(_keyRepsPerSeries) ?? 10;
    restTimeSeconds = prefs.getInt(_keyRestTime) ?? 90;
  }

  Future<void> saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTotalSets, totalSets);
    await prefs.setInt(_keySeriesPerSet, seriesPerSet);
    await prefs.setInt(_keyRepsPerSeries, repsPerSeries);
    await prefs.setInt(_keyRestTime, restTimeSeconds);
  }
}
