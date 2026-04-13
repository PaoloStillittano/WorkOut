import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class WorkoutControls extends StatelessWidget {
  final bool isWorkoutRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const WorkoutControls({
    super.key,
    required this.isWorkoutRunning,
    required this.onStart,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 64,
            child: ElevatedButton.icon(
              icon: Icon(
                isWorkoutRunning ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: AppDimensions.iconMedium,
              ),
              label: Text(
                isWorkoutRunning ? 'Pause' : 'Start',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
              ),
              onPressed: isWorkoutRunning ? onPause : onStart,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.p16),
        Expanded(
          child: SizedBox(
            height: 64,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.stop_outlined, // Uses a square stop line icon
                color: Colors.white,
                size: AppDimensions.iconMedium,
              ),
              label: const Text(
                'Stop',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stopRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
              ),
              onPressed: onStop,
            ),
          ),
        ),
      ],
    );
  }
}

