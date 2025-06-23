// lib/widgets/pp_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withAlpha(30),
              colorScheme.secondary.withAlpha(20),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
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
        Consumer<ThemeController>(
          builder: (context, themeController, child) => Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                themeController.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                color: colorScheme.primary,
              ),
              onPressed: () {
                themeController.setThemeMode(
                  themeController.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                );
              },
              tooltip: themeController.themeMode == ThemeMode.dark
                  ? 'Passa al tema chiaro'
                  : 'Passa al tema scuro',
            ),
          ),
        ),
        // Pulsante delle impostazioni
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
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