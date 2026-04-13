import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class WorkoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsPressed;
  final VoidCallback onHistoryPressed;

  const WorkoutAppBar({
    super.key,
    required this.onSettingsPressed,
    required this.onHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('WorkOut', style: AppTypography.headlineMedium),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.history_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: onHistoryPressed,
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: onSettingsPressed,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}