import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../../history/viewmodels/history_viewmodel.dart';
import 'package:intl/intl.dart';
import 'widgets/history_summary.dart';
import 'widgets/workout_history_item.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Consumer<HistoryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Section
                HistorySummary(
                  totalWorkouts: viewModel.totalWorkouts,
                  totalDurationSeconds: viewModel.totalDurationSeconds,
                  totalReps: viewModel.totalReps,
                ),
                
                const SizedBox(height: 24),

                // Heatmap Section
                _buildSectionHeader(context, 'Consistency'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withAlpha(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HeatMap(
                    datasets: viewModel.heatmapDatasets,
                    colorMode: ColorMode.opacity,
                    showText: false,
                    scrollable: true,
                    colorsets: {
                      1: colorScheme.primary,
                    },
                    onClick: (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(DateFormat.yMMMd().format(value))),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Activity Section
                _buildSectionHeader(context, 'Recent Activity'),
                const SizedBox(height: 12),

                if (viewModel.sessions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.fitness_center_outlined,
                            size: 48,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No workouts yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Start training to see your history!',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant.withAlpha(200),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.sessions.length,
                    itemBuilder: (context, index) {
                      // Reverse index to show newest first if the list is chronological
                      // Assuming viewModel.sessions is already sorted newest first?
                      // If not, we should sort it in the viewmodel. 
                      // Let's assume the viewmodel provides them in the correct order for now.
                      final session = viewModel.sessions[index];
                      return WorkoutHistoryItem(session: session);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
