import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../history/viewmodels/history_viewmodel.dart';
import 'package:intl/intl.dart';
import 'widgets/history_summary.dart';
import 'widgets/workout_history_item.dart';
import 'widgets/workout_heatmap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_dimensions.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Workout History', style: AppTypography.headlineMedium),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
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

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.p16),
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
                
                const SizedBox(height: AppDimensions.p24),

                // Heatmap Section
                _buildSectionHeader(context, 'Consistency'),
                const SizedBox(height: AppDimensions.p12),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.p16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppDimensions.radius16),
                  ),
                  child: WorkoutHeatmap(
                    datasets: viewModel.heatmapDatasets,
                    primaryColor: AppColors.primaryBlue,
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

                const SizedBox(height: AppDimensions.p24),

                // Recent Activity Section with Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader(context, 'Recent Activity'),
                  ],
                ),
                const SizedBox(height: AppDimensions.p12),

                // Filter Chips
                Row(
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: AppDimensions.p8),
                    _buildFilterChip('Push'),
                    const SizedBox(width: AppDimensions.p8),
                    _buildFilterChip('Pull'),
                  ],
                ),
                const SizedBox(height: AppDimensions.p16),

                if (filteredSessions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.p32),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.fitness_center_outlined,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: AppDimensions.p16),
                          Text(
                            _selectedFilter == 'All' 
                                ? 'No workouts yet'
                                : 'No $_selectedFilter workouts',
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: AppDimensions.p8),
                          const Text(
                            'Start training to see your history!',
                            style: AppTypography.labelLarge,
                          ),
                          if (_selectedFilter == 'All') ...[
                            const SizedBox(height: AppDimensions.p16),
                            FilledButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.fitness_center),
                              label: const Text('Start Workout'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                              ),
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
           ),
          ),
        );
      },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTypography.titleLarge,
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: AppColors.cardBackground,
      selectedColor: AppColors.primaryBlue.withAlpha(100),
      checkmarkColor: AppColors.textPrimary,
      labelStyle: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        side: BorderSide.none,
      ),
    );
  }
}

