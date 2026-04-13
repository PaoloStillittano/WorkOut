import 'package:flutter/material.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';

class WorkoutTimers extends StatelessWidget {
  final int workoutSeconds;
  final int pauseSeconds;
  final bool isPauseRunning;
  final VoidCallback onStartPause;
  final VoidCallback onStopPause;

  const WorkoutTimers({
    super.key,
    required this.workoutSeconds,
    required this.pauseSeconds,
    required this.isPauseRunning,
    required this.onStartPause,
    required this.onStopPause,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radius16),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.p32, horizontal: AppDimensions.p8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Workout',
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: AppDimensions.p12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    TimeFormatter.formatSeconds(workoutSeconds),
                    style: AppTypography.displayTimer,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.p16),
        Expanded(
          child: GestureDetector(
            onTap: isPauseRunning ? onStopPause : onStartPause,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radius16),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.p32, horizontal: AppDimensions.p8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Break',
                    style: AppTypography.labelLarge,
                  ),
                  const SizedBox(height: AppDimensions.p12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      TimeFormatter.formatSeconds(pauseSeconds),
                      style: AppTypography.displayTimer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
