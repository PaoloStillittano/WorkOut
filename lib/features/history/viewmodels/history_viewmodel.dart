import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/workout_session.dart';
import '../data/repositories/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryRepository _repository = HistoryRepository();
  
  List<WorkoutSession> _sessions = [];
  List<WorkoutSession> get sessions => _sessions;

  Map<DateTime, int> _heatmapDatasets = {};
  Map<DateTime, int> get heatmapDatasets => _heatmapDatasets;

  int get totalWorkouts => _sessions.length;
  
  int get totalDurationSeconds {
    return _sessions.fold(0, (sum, session) => sum + session.durationSeconds);
  }

  int get totalReps {
    return _sessions.fold(0, (sum, session) => sum + session.totalReps);
  }

  int get currentStreak {
    if (_sessions.isEmpty) return 0;
    
    int streak = 0;
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    
    for (int i = 0; i < 365; i++) {
      final checkDate = normalizedToday.subtract(Duration(days: i));
      final hasWorkout = _sessions.any((session) {
        final sessionDate = DateTime(session.date.year, session.date.month, session.date.day);
        return sessionDate.isAtSameMomentAs(checkDate);
      });
      
      if (hasWorkout) {
        streak++;
      } else if (i > 0) {
        // Only break if it's not today (allow for no workout today)
        break;
      }
    }
    
    return streak;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HistoryViewModel() {
    loadSessions();
  }

  Future<void> loadSessions() async {
    _isLoading = true;
    notifyListeners();

    _sessions = await _repository.getAllSessions();
    _generateHeatmapData();

    _isLoading = false;
    notifyListeners();
    
    // Watch for changes
    final box = await Hive.openBox<WorkoutSession>(HistoryRepository.boxName);
    box.listenable().addListener(() {
      _refreshSessions();
    });
  }

  Future<void> _refreshSessions() async {
    _sessions = await _repository.getAllSessions();
    _generateHeatmapData();
    notifyListeners();
  }

  void _generateHeatmapData() {
    _heatmapDatasets = {};
    for (var session in _sessions) {
      // Normalize date to remove time
      final date = DateTime(session.date.year, session.date.month, session.date.day);
      
      // Increment count for this date (or use intensity based on reps/duration)
      // For now, let's just count number of workouts, or maybe total reps?
      // Let's use total reps as intensity for the color
      final currentIntensity = _heatmapDatasets[date] ?? 0;
      _heatmapDatasets[date] = currentIntensity + session.totalReps;
    }
  }

  Future<void> addSession(WorkoutSession session) async {
    await _repository.saveSession(session);
    await loadSessions();
  }

  Future<void> deleteSession(String id) async {
    await _repository.deleteSession(id);
    await loadSessions();
  }
}
