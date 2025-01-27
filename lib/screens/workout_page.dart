import 'package:flutter/material.dart';
import '../screens/config_page.dart';
import '../widgets/timer_display.dart';
import '../widgets/workout_controls.dart';
import '../widgets/counter_display.dart';
import '../widgets/workout_timers.dart';
import '../controllers/workout_controller.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'W',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        (Theme.of(context).textTheme.titleLarge?.fontSize ??
                                18.0) *
                            1.2,
                    letterSpacing: 2.0),
              ),
              TextSpan(
                text: 'ork',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(letterSpacing: 3.0),
              ),
              TextSpan(
                text: 'O',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        (Theme.of(context).textTheme.titleLarge?.fontSize ??
                                18.0) *
                            1.2,
                    letterSpacing: 2.0),
              ),
              TextSpan(
                text: 'ut',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          // Pulsante per il tema
          Consumer<ThemeController>(
            builder: (context, themeController, child) => IconButton(
              icon: Icon(
                themeController.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                themeController.setThemeMode(
                  themeController.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                );
              },
              tooltip: themeController.themeMode == ThemeMode.dark
                  ? 'Passa al tema chiaro'
                  : 'Passa al tema scuro',
            ),
          ),
          // Pulsante delle impostazioni
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigPage()),
              );
              await controller.reloadConfig();
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TimerDisplay(currentTime: controller.currentTime),
            WorkoutTimers(
              workoutSeconds: controller.workoutSeconds,
              pauseSeconds: controller.pauseSeconds,
              isPauseRunning: controller.isPauseRunning,
              onStartPause: controller.startPauseTimer,
              onStopPause: controller.stopPauseTimer,
            ),
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
            WorkoutControls(
              isWorkoutRunning: controller.isWorkoutRunning,
              onStart: controller.startWorkoutTimer,
              onPause: controller.pauseWorkoutTimer,
              onStop: controller.stopWorkout,
            ),
          ],
        ),
      ),
    );
  }
}
