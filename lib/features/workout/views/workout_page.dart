import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/workout_viewmodel.dart';
import '../../settings/views/config_page.dart';
import 'widgets/timer_display.dart';
import 'widgets/workout_controls.dart';
import 'widgets/counter_display.dart';
import 'widgets/workout_timers.dart';
import 'widgets/workout_app_bar.dart';
import '../../../core/constants/app_constants.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late WorkoutViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WorkoutViewModel();
    
    // Setup callbacks
    _viewModel.onPauseFinished = () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pausa terminata!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    };

    _viewModel.onWorkoutStopped = () {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(
              const Duration(seconds: AppConstants.modalDurationSeconds),
              () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            );

            return const AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              title: Text('Allenamento Terminato'),
              content: Text('Allenamento interrotto e dati resettati.'),
            );
          },
        );
      }
    };
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _navigateToConfig() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigPage()),
    );
    await _viewModel.reloadConfig();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the ViewModel to the widget tree
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<WorkoutViewModel>(
        builder: (context, viewModel, child) {
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
                      // Note: We need to pass a formatted string or handle formatting in TimerDisplay
                      // For now, let's assume TimerDisplay expects a string.
                      // We can format TimeOfDay here or in ViewModel. 
                      // ViewModel exposes TimeOfDay, let's format it here.
                      TimerDisplay(currentTime: viewModel.timeOfDay.format(context)),

                      const SizedBox(height: 15),

                      // Workout Type Selector
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'Push', 
                            label: Text('Push'), 
                            icon: Icon(Icons.arrow_upward)
                          ),
                          ButtonSegment(
                            value: 'Pull', 
                            label: Text('Pull'), 
                            icon: Icon(Icons.arrow_downward)
                          ),
                        ],
                        selected: {viewModel.workoutType},
                        onSelectionChanged: (Set<String> newSelection) {
                          viewModel.setWorkoutType(newSelection.first);
                        },
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Timer di workout e pausa
                      WorkoutTimers(
                        workoutSeconds: viewModel.workoutSeconds,
                        pauseSeconds: viewModel.pauseSeconds,
                        isPauseRunning: viewModel.isPauseRunning,
                        onStartPause: viewModel.startPauseTimer,
                        onStopPause: viewModel.stopPauseTimer,
                      ),

                      const SizedBox(height: 10),

                      // Contatori (Set, Serie, Ripetizioni)
                      CounterDisplay(
                        sets: viewModel.sets,
                        series: viewModel.series,
                        reps: viewModel.reps,
                        maxSets: viewModel.maxSets,
                        maxSeries: viewModel.maxSeries,
                        maxReps: viewModel.maxReps,
                        onIncrementReps: viewModel.incrementReps,
                        onDecrementReps: viewModel.decrementReps,
                      ),

                      const SizedBox(height: 6),

                      // Controlli workout
                      WorkoutControls(
                        isWorkoutRunning: viewModel.isWorkoutRunning,
                        onStart: viewModel.startWorkoutTimer,
                        onPause: viewModel.pauseWorkoutTimer,
                        onStop: viewModel.stopWorkout,
                      ),

                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
