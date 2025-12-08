import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isWorkoutRunning
                      ? [
                          colorScheme.secondary,
                          colorScheme.secondary.withAlpha(200),
                        ]
                      : [
                          colorScheme.primary,
                          colorScheme.primary.withAlpha(200),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isWorkoutRunning ? Icons.pause : Icons.play_arrow,
                    key: ValueKey(isWorkoutRunning),
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    isWorkoutRunning ? 'Pausa' : 'Avvia',
                    key: ValueKey(isWorkoutRunning),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: isWorkoutRunning ? onPause : onStart,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Bottone Stop
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(240),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.stop,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text(
                  'Stop',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: onStop,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
