// lib/controllers/workout_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../constants/workout_constants.dart';
import 'config_controller.dart';
import 'package:audioplayers/audioplayers.dart';

class WorkoutController extends ChangeNotifier {
  String currentTime = "";
  int workoutSeconds = 0;
  int pauseSeconds = 90;

  // Rimuoviamo final per permettere l'aggiornamento dai settings
  int _maxSets = WorkoutConstants.maxSets;
  int _maxSeries = WorkoutConstants.maxSeries;
  int _maxReps = WorkoutConstants.maxReps;

  // Getters per i valori massimi
  int get maxSets => _maxSets;
  int get maxSeries => _maxSeries;
  int get maxReps => _maxReps;

  int sets = 0;
  int series = 0;
  int reps = 0;

  bool isWorkoutRunning = false;
  bool isPauseRunning = false;

  Timer? workoutTimer;
  Timer? pauseTimer;
  Timer? clockTimer;

  late ConfigController configController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  BuildContext? _context;

  WorkoutController() {
    configController = ConfigController();
    _initializeConfig();
  }

  Future<void> _initializeConfig() async {
    await configController.loadConfig();
    _maxSets = configController.totalSets;
    _maxSeries = configController.seriesPerSet;
    _maxReps = configController.repsPerSeries;
    pauseSeconds = configController.restTimeSeconds;
    notifyListeners();
  }

  Future<void> reloadConfig() async {
    await configController.loadConfig();
    _maxSets = configController.totalSets;
    _maxSeries = configController.seriesPerSet;
    _maxReps = configController.repsPerSeries;
    if (!isPauseRunning) {
      pauseSeconds = configController.restTimeSeconds;
    }

    // if (sets > _maxSets) sets = _maxSets;
    // if (series > _maxSeries) series = _maxSeries;
    // if (reps > _maxReps) reps = _maxReps;

    notifyListeners();
  }

  Future<void> playNotificationSound() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
      // Backup plan se il suono principale non funziona
      await HapticFeedback.vibrate();
      debugPrint('Sound played successfully');
    } catch (e) {
      debugPrint('Error playing sound: $e');
      try {
        // Prova con un altro tipo di suono
        await SystemSound.play(SystemSoundType.click);
      } catch (e) {
        debugPrint('Error playing backup sound: $e');
      }
    }
  }

  void setContext(BuildContext context) {
    _context = context;
    currentTime = TimeOfDay.now().format(context);
    notifyListeners();
  }

  void initializeTimers() {
    clockTimer?.cancel();
    clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_context != null) {
        currentTime = TimeOfDay.now().format(_context!);
        notifyListeners();
      }
    });
  }

  void startWorkoutTimer() {
    if (workoutTimer != null && workoutTimer!.isActive) return;

    workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      workoutSeconds++;
      notifyListeners();
    });
    isWorkoutRunning = true;
    notifyListeners();
  }

  void pauseWorkoutTimer() {
    workoutTimer?.cancel();
    isWorkoutRunning = false;
    notifyListeners();
  }

  void startPauseTimer() {
    if (pauseTimer != null && pauseTimer!.isActive) return;
    if (isPauseRunning) return;

    pauseSeconds = configController.restTimeSeconds;
    isPauseRunning = true;
    notifyListeners();

    pauseTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (pauseSeconds > 0) {
        pauseSeconds--;
        notifyListeners();
      } else {
        stopPauseTimer();
        if (_context != null && _context!.mounted) {
          try {
            // Usa AssetSource invece di UrlSource
            await _audioPlayer.play(AssetSource('sounds/single_beep.mp3'));

            ScaffoldMessenger.of(_context!).showSnackBar(
              const SnackBar(
                content: Text('Pausa terminata!'),
                duration: Duration(seconds: 2),
              ),
            );
          } catch (e) {
            debugPrint('Error playing sound: $e');
          }
        }
      }
    });
  }

  void stopPauseTimer() {
    pauseTimer?.cancel();
    isPauseRunning = false;
    pauseSeconds = configController.restTimeSeconds;
    notifyListeners();
  }

  void incrementReps() {
    int newReps = reps + _maxReps;

    if (newReps >= reps + _maxReps) {
        series++;
        if (series >= _maxSeries) {
            series = 0;
            sets++;
        }
    }

    reps = newReps;
    notifyListeners();
}

  void decrementReps() {
    int newReps = reps - _maxReps;

    if (newReps < 0) return;

    // Se stiamo per decrementare oltre l'inizio della serie corrente
    if (series > 0 || sets > 0) {
        if (series > 0) {
            series--;
        } else if (sets > 0) {
            sets--;
            series = _maxSeries - 1;  // Torna all'ultima serie del set precedente
        }
    }

    reps = newReps;
    notifyListeners();
}

  void incrementSeries() {
    if (series < _maxSeries) {
      series++;
      if (series == _maxSeries) {
        series = 0;
        incrementSets();
      }
      notifyListeners();
    }
  }

  void incrementSets() {
    if (sets < _maxSets) {
      sets++;
      // if (sets == _maxSets) {
      //   stopWorkout();
      // }
      notifyListeners();
    }
  }

  void stopWorkout() async {
    // Aggiungiamo async
    workoutTimer?.cancel();
    pauseTimer?.cancel();

    isWorkoutRunning = false;
    isPauseRunning = false;

    workoutSeconds = 0;
    pauseSeconds = configController.restTimeSeconds;

    sets = 0;
    series = 0;
    reps = 0;

    notifyListeners();

    if (_context != null && _context!.mounted) {
      // Riproduciamo il suono
      try {
        await _audioPlayer.play(AssetSource('sounds/single_beep.mp3'));
      } catch (e) {
        debugPrint('Error playing sound: $e');
      }

      showDialog(
        context: _context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(
            const Duration(seconds: WorkoutConstants.modalDurationSeconds),
            () {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          );

          return const AlertDialog(
            title: Text('Allenamento Terminato'),
            content: Text('Allenamento interrotto e dati resettati.'),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    workoutTimer?.cancel();
    pauseTimer?.cancel();
    clockTimer?.cancel();
    super.dispose();
  }
}
