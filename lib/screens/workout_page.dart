import 'package:flutter/material.dart';
import '../screens/config_page.dart';
import '../widgets/timer_display.dart';
import '../widgets/workout_controls.dart';
import '../widgets/counter_display.dart';
import '../widgets/workout_timers.dart';
import '../controllers/workout_controller.dart';
import '../widgets/app_bar.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final WorkoutController controller = WorkoutController();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller.initializeTimers();
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      controller.setContext(context);
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _navigateToConfig() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigPage()),
    );
    await controller.reloadConfig();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: WorkoutAppBar(
        onSettingsPressed: _navigateToConfig,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.background,
              colorScheme.surface.withAlpha(50),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Timer principale
                TimerDisplay(currentTime: controller.currentTime),

                const SizedBox(height: 15),

                // Timer di workout e pausa
                WorkoutTimers(
                  workoutSeconds: controller.workoutSeconds,
                  pauseSeconds: controller.pauseSeconds,
                  isPauseRunning: controller.isPauseRunning,
                  onStartPause: controller.startPauseTimer,
                  onStopPause: controller.stopPauseTimer,
                ),

                const SizedBox(height: 10),

                // Contatori (Set, Serie, Ripetizioni)
                CounterDisplay(
                  sets: controller.sets,
                  series: controller.series,
                  reps: controller.reps,
                  maxSets: controller.maxSets,
                  maxSeries: controller.maxSeries,
                  maxReps: controller.maxReps,
                  onIncrementReps: controller.incrementReps,
                  onDecrementReps: controller.decrementReps,
                ),

                const SizedBox(height: 6),

                // Controlli workout
                WorkoutControls(
                  isWorkoutRunning: controller.isWorkoutRunning,
                  onStart: controller.startWorkoutTimer,
                  onPause: controller.pauseWorkoutTimer,
                  onStop: controller.stopWorkout,
                ),

                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
