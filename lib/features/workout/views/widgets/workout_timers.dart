import 'package:flutter/material.dart';
import '../../../../core/utils/time_formatter.dart';

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

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.white.withAlpha(40),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tempo Allenamento',
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          TimeFormatter.formatSeconds(workoutSeconds),
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                margin: const EdgeInsets.all(6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white.withAlpha(40),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isPauseRunning
                            ? 'Pausa in corso'
                            : 'Tap per iniziare pausa',
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            TimeFormatter.formatSeconds(pauseSeconds),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: isPauseRunning
                                  ? Theme.of(context).colorScheme.primary
                                  : textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
