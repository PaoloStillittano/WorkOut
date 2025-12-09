import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../history/viewmodels/history_viewmodel.dart';
import 'package:intl/intl.dart';
import 'widgets/history_summary.dart';
import 'widgets/workout_history_item.dart';
import 'widgets/workout_heatmap.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'All';

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

          // Filter sessions based on selected filter
          final filteredSessions = _selectedFilter == 'All'
              ? viewModel.sessions
              : viewModel.sessions.where((s) => s.workoutType == _selectedFilter).toList();

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
                  currentStreak: viewModel.currentStreak,
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
                  child: WorkoutHeatmap(
                    datasets: viewModel.heatmapDatasets,
                    primaryColor: colorScheme.primary,
                    onTap: (value) {
                      final workoutsOnDate = viewModel.sessions
                          .where((s) => 
                            s.date.year == value.year &&
                            s.date.month == value.month &&
                            s.date.day == value.day)
                          .length;
                      
                      if (workoutsOnDate > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${DateFormat.yMMMd().format(value)}: $workoutsOnDate workout${workoutsOnDate != 1 ? 's' : ''}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Activity Section with Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader(context, 'Recent Activity'),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter Chips
                Row(
                  children: [
                    _buildFilterChip('All', colorScheme),
                    const SizedBox(width: 8),
                    _buildFilterChip('Push', colorScheme),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pull', colorScheme),
                  ],
                ),
                const SizedBox(height: 12),

                if (filteredSessions.isEmpty)
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
                            _selectedFilter == 'All' 
                                ? 'No workouts yet'
                                : 'No $_selectedFilter workouts',
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start training to see your history!',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant.withAlpha(200),
                            ),
                          ),
                          if (_selectedFilter == 'All') ...[
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.fitness_center),
                              label: const Text('Start Workout'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredSessions.length,
                    itemBuilder: (context, index) {
                      final session = filteredSessions[index];
                      return WorkoutHistoryItem(
                        session: session,
                        onDelete: (id) => viewModel.deleteSession(id),
                      );
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

  Widget _buildFilterChip(String label, ColorScheme colorScheme) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
      ),
    );
  }
}
