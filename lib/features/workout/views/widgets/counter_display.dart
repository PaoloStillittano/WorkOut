import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';

class CounterDisplay extends StatelessWidget {
  final int sets;
  final int series;
  final int reps;
  final int maxSets;
  final int maxSeries;
  final int maxReps;
  final VoidCallback onIncrementReps;
  final VoidCallback onDecrementReps;

  const CounterDisplay({
    super.key,
    required this.sets,
    required this.series,
    required this.reps,
    required this.maxSets,
    required this.maxSeries,
    required this.maxReps,
    required this.onIncrementReps,
    required this.onDecrementReps,
  });

  Widget _buildCounterColumn(String label, String value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: AppDimensions.p12),
          Text(
            value,
            style: AppTypography.headlineMedium,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.p24, horizontal: AppDimensions.p16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCounterColumn('Sets', '$sets/$maxSets'), // Currently it was sets+1, let's keep it just sets, wait the image says 0 / 6
              _buildCounterColumn('Series', '$series/$maxSeries'),
              _buildCounterColumn('Reps', '$reps'),
            ],
          ),
          const SizedBox(height: AppDimensions.p32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundButton(Icons.remove, onDecrementReps),
              const SizedBox(width: AppDimensions.p32),
              _buildRoundButton(Icons.add, onIncrementReps),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: AppColors.cardBackgroundLight,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.p16),
          child: Icon(
            icon,
            size: AppDimensions.iconLarge,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}