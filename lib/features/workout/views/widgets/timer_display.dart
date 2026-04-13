import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';

class TimerDisplay extends StatelessWidget {
  final DateTime currentDateTime;

  const TimerDisplay({
    super.key,
    required this.currentDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = "${currentDateTime.hour.toString().padLeft(2, '0')}:${currentDateTime.minute.toString().padLeft(2, '0')}:${currentDateTime.second.toString().padLeft(2, '0')}";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.p32, horizontal: AppDimensions.p16),
      child: Column(
        children: [
          const Text(
            'Current Time',
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: AppDimensions.p12),
          Text(
            timeString,
            style: AppTypography.displayMedium,
          ),
        ],
      ),
    );
  }
}