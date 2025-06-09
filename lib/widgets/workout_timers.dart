import 'package:flutter/material.dart';
import '../utils/time_formatter.dart';

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
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Colors.white.withAlpha(150),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Tempo Allenamento',
                    style: TextStyle(
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                  Text(
                    TimeFormatter.formatSeconds(workoutSeconds),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: isPauseRunning ? onStopPause : onStartPause,
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.white.withAlpha(150),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      isPauseRunning
                          ? 'Pausa in corso'
                          : 'Tap per iniziare pausa',
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                    ),
                    Text(
                      TimeFormatter.formatSeconds(pauseSeconds),
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: isPauseRunning
                            ? Theme.of(context).colorScheme.primary
                            : textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
