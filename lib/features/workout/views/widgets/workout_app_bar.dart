// lib/features/workout/views/widgets/workout_app_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class WorkoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsPressed;

  const WorkoutAppBar({
    super.key,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'W',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (Theme.of(context).textTheme.titleLarge?.fontSize ?? 18.0) * 1.2,
                      letterSpacing: 2.0,
                      color: colorScheme.primary,
                    ),
              ),
              TextSpan(
                text: 'ork',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      letterSpacing: 3.0,
                      color: colorScheme.primary,
                    ),
              ),
              TextSpan(
                text: 'O',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (Theme.of(context).textTheme.titleLarge?.fontSize ?? 18.0) * 1.2,
                      letterSpacing: 2.0,
                      color: colorScheme.secondary,
                    ),
              ),
              TextSpan(
                text: 'ut',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.secondary,
                    ),
              ),
            ],
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        // Pulsante per il tema
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) => Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                color: colorScheme.primary,
              ),
              onPressed: () {
                themeProvider.setThemeMode(
                  themeProvider.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                );
              },
              tooltip: themeProvider.themeMode == ThemeMode.dark
                  ? 'Passa al tema chiaro'
                  : 'Passa al tema scuro',
            ),
          ),
        ),
        // Pulsante delle impostazioni
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: colorScheme.primary,
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