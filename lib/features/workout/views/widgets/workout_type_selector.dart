import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class WorkoutTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const WorkoutTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: AppDimensions.p16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.arrow_upward,
                  size: AppDimensions.iconMedium,
                  color: selectedType == 'Push' ? Colors.white : AppColors.textSecondary,
                ),
                label: Text(
                  'Push',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: selectedType == 'Push' ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType == 'Push' ? AppColors.primaryBlue : AppColors.cardBackgroundLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
                onPressed: () => onTypeChanged('Push'),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.p12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.arrow_downward,
                  size: AppDimensions.iconMedium,
                  color: selectedType == 'Pull' ? Colors.white : AppColors.textSecondary,
                ),
                label: Text(
                  'Pull',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: selectedType == 'Pull' ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType == 'Pull' ? AppColors.primaryBlue : AppColors.cardBackgroundLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
                onPressed: () => onTypeChanged('Pull'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}