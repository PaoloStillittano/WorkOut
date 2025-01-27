import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int sets;
  final int series;
  final int reps;
  final int maxSets;
  final int maxSeries;
  final int maxReps;
  final VoidCallback onIncrementReps;
  final VoidCallback onDecrementReps;

  const CounterDisplay({
    super.key,
    required this.sets,
    required this.series,
    required this.reps,
    required this.maxSets,
    required this.maxSeries,
    required this.maxReps,
    required this.onIncrementReps,
    required this.onDecrementReps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text('Set', style: TextStyle(fontSize: 20)),
                Text(
                  '${sets + 1}/$maxSets',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            Column(
              children: [
                const Text('Serie', style: TextStyle(fontSize: 20)),
                Text(
                  '$series/$maxSeries',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            Column(
              children: [
                const Text('Ripetizioni', style: TextStyle(fontSize: 20)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: onDecrementReps,
                    ),
                    Text(
                      '$reps',
                      style: const TextStyle(fontSize: 30),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: onIncrementReps,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
