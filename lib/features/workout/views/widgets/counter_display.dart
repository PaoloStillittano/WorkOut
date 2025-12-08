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

  // Helper widget per le card informative in cima (Set e Serie)
  Widget _buildInfoCard({required String label, required String value}) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.white.withAlpha(40),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Prima riga per Set e Serie
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(label: 'Set', value: '${sets + 1}/$maxSets'),
              const SizedBox(width: 6),
              _buildInfoCard(label: 'Serie', value: '$series/$maxSeries'),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Seconda riga per il contatore delle Ripetizioni
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withAlpha(40),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              children: [
                const Text(
                  'Ripetizioni',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Pulsante Decremento
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      iconSize: 40,
                      color: colorScheme.secondary,
                      onPressed: onDecrementReps,
                    ),
                    // Conteggio
                    Expanded(
                      child: Text(
                        '$reps',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Pulsante Incremento
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 40,
                      color: colorScheme.primary,
                      onPressed: onIncrementReps,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}