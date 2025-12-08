import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class WorkoutViewModel extends ChangeNotifier {
  String _currentTime = "";
  int _workoutSeconds = 0;
  int _pauseSeconds = 90;

  int _maxSets = AppConstants.maxSets;
  int _maxSeries = AppConstants.maxSeries;
  int _maxReps = AppConstants.maxReps;

  int get maxSets => _maxSets;
  int get maxSeries => _maxSeries;
  int get maxReps => _maxReps;

  int _sets = 0;
  int _series = 0;
  int _reps = 0;

  int get sets => _sets;
  int get series => _series;
  int get reps => _reps;

  bool _isWorkoutRunning = false;
  bool _isPauseRunning = false;

  bool get isWorkoutRunning => _isWorkoutRunning;
  bool get isPauseRunning => _isPauseRunning;

  String get currentTime => _currentTime;
  int get workoutSeconds => _workoutSeconds;
  int get pauseSeconds => _pauseSeconds;

  Timer? _workoutTimer;
  Timer? _pauseTimer;
  Timer? _clockTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Events
  Function()? onPauseFinished;
  Function()? onWorkoutStopped;

  WorkoutViewModel() {
    _initializeConfig();
    _startClock();
  }

  Future<void> _initializeConfig() async {
    await reloadConfig();
  }

  Future<void> reloadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _maxSets = prefs.getInt(AppConstants.keyTotalSets) ?? 5;
    _maxSeries = prefs.getInt(AppConstants.keySeriesPerSet) ?? 4;
    _maxReps = prefs.getInt(AppConstants.keyRepsPerSeries) ?? 10;
    
    if (!_isPauseRunning) {
      _pauseSeconds = prefs.getInt(AppConstants.keyRestTime) ?? 90;
    }
    notifyListeners();
  }

  void _startClock() {
    _clockTimer?.cancel();
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = TimeOfDay.now();
    // We can't format without context here easily if we want localized format, 
    // but for now we'll just store the TimeOfDay or a string. 
    // Actually, TimeOfDay.format needs context for 24h/12h preference.
    // We'll expose TimeOfDay and let the View format it, or use a fixed format.
    // Let's use a simple string for now, or better, expose DateTime/TimeOfDay.
    // The original code used TimeOfDay.now().format(context).
    // To keep it clean, we'll expose TimeOfDay and let the UI handle formatting.
    notifyListeners();
  }
  
  TimeOfDay get timeOfDay => TimeOfDay.now();

  void startWorkoutTimer() {
    if (_workoutTimer != null && _workoutTimer!.isActive) return;

    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _workoutSeconds++;
      notifyListeners();
    });
    _isWorkoutRunning = true;
    notifyListeners();
  }

  void pauseWorkoutTimer() {
    _workoutTimer?.cancel();
    _isWorkoutRunning = false;
    notifyListeners();
  }

  void startPauseTimer() {
    if (_pauseTimer != null && _pauseTimer!.isActive) return;
    if (_isPauseRunning) return;

    // Reset pause seconds from config
    SharedPreferences.getInstance().then((prefs) {
        _pauseSeconds = prefs.getInt(AppConstants.keyRestTime) ?? 90;
        _isPauseRunning = true;
        notifyListeners();

        _pauseTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (_pauseSeconds > 0) {
            _pauseSeconds--;
            notifyListeners();
          } else {
            stopPauseTimer();
            _playBeep();
            onPauseFinished?.call();
          }
        });
    });
  }

  void stopPauseTimer() {
    _pauseTimer?.cancel();
    _isPauseRunning = false;
    SharedPreferences.getInstance().then((prefs) {
        _pauseSeconds = prefs.getInt(AppConstants.keyRestTime) ?? 90;
        notifyListeners();
    });
  }

  void incrementReps() {
    bool isFirstRep = (_reps == 0 && _series == 0 && _sets == 0);
    
    int newReps = _reps + _maxReps;

    if (newReps >= _reps + _maxReps) {
        _series++;
        if (_series >= _maxSeries) {
            _series = 0;
            _sets++;
        }
    }

    _reps = newReps;
    
    if (isFirstRep && !_isWorkoutRunning) {
      startWorkoutTimer();
    }
    
    notifyListeners();
  }

  void decrementReps() {
    int newReps = _reps - _maxReps;

    if (newReps < 0) return;

    if (_series > 0 || _sets > 0) {
        if (_series > 0) {
            _series--;
        } else if (_sets > 0) {
            _sets--;
            _series = _maxSeries - 1;  
        }
    }

    _reps = newReps;
    
    if (_reps == 0 && _series == 0 && _sets == 0 && _isWorkoutRunning) {
      pauseWorkoutTimer();
    }
    
    notifyListeners();
  }

  void incrementSeries() {
    if (_series < _maxSeries) {
      _series++;
      if (_series == _maxSeries) {
        _series = 0;
        incrementSets();
      }
      notifyListeners();
    }
  }

  void incrementSets() {
    if (_sets < _maxSets) {
      _sets++;
      notifyListeners();
    }
  }

  void stopWorkout() async {
    _workoutTimer?.cancel();
    _pauseTimer?.cancel();

    _isWorkoutRunning = false;
    _isPauseRunning = false;

    _workoutSeconds = 0;
    
    final prefs = await SharedPreferences.getInstance();
    _pauseSeconds = prefs.getInt(AppConstants.keyRestTime) ?? 90;

    _sets = 0;
    _series = 0;
    _reps = 0;

    notifyListeners();
    
    _playBeep();
    onWorkoutStopped?.call();
  }

  Future<void> _playBeep() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/single_beep.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _workoutTimer?.cancel();
    _pauseTimer?.cancel();
    _clockTimer?.cancel();
    super.dispose();
  }
}
