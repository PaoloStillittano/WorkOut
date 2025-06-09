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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Start/Pause Button
        ElevatedButton.icon(
          icon: Icon(
            isWorkoutRunning ? Icons.pause : Icons.play_arrow,
            size: 24,
            color: Colors.white,
          ),
          label: Text(
            isWorkoutRunning ? 'Pausa' : 'Avvia',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            backgroundColor:
                isWorkoutRunning ? colorScheme.secondary : colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: isWorkoutRunning ? onPause : onStart,
        ),
        // Stop Button
        ElevatedButton.icon(
          icon: const Icon(
            Icons.stop,
            size: 24,
            color: Colors.white,
          ),
          label: const Text(
            'Stop',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: onStop,
        ),
      ],
    );
  }
}
