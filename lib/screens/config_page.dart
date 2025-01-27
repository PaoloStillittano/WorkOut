import 'package:flutter/material.dart';
import '../controllers/config_controller.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late ConfigController controller;

  @override
  void initState() {
    super.initState();
    controller = ConfigController();
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    await controller.loadConfig();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurazione'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impostazioni Allenamento',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Set Configuration
            _buildNumberInput(
              label: 'Numero di Set',
              value: controller.totalSets,
              onChanged: (value) {
                setState(() {
                  controller.totalSets = value;
                });
              },
              minValue: 1,
            ),

            const SizedBox(height: 16),

            // Series Configuration
            _buildNumberInput(
              label: 'Serie per Set',
              value: controller.seriesPerSet,
              onChanged: (value) {
                setState(() {
                  controller.seriesPerSet = value;
                });
              },
              minValue: 1,
            ),

            const SizedBox(height: 16),

            // Reps Configuration
            _buildNumberInput(
              label: 'Ripetizioni per Serie',
              value: controller.repsPerSeries,
              onChanged: (value) {
                setState(() {
                  controller.repsPerSeries = value;
                });
              },
              minValue: 1,
              maxValue: 40,
              helperText:
                  'Questo valore determina sia il numero di ripetizioni per serie che l\'incremento quando premi + o -',
            ),

            const SizedBox(height: 16),

            // Rest Time Configuration
            _buildNumberInput(
              label: 'Tempo di Recupero (secondi)',
              value: controller.restTimeSeconds,
              onChanged: (value) {
                setState(() {
                  controller.restTimeSeconds = value;
                });
              },
              minValue: 5,
              step: 5,
            ),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.save,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text(
                  'Salva Configurazione',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary, // Usa il colore primario
                  foregroundColor:
                      Colors.white, // Colore del testo e dell'icona
                ),
                onPressed: () async {
                  await controller.saveConfig();
                  if (mounted && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required int value,
    required Function(int) onChanged,
    int? minValue,
    int? maxValue,
    String? helperText,
    int step = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                if (value > (minValue ?? 1)) {
                  // Usiamo step per il decremento
                  final newValue = value - step;
                  // Assicuriamoci di non andare sotto il minimo
                  if (newValue >= (minValue ?? 1)) {
                    onChanged(newValue);
                  } else {
                    onChanged(minValue ?? 1);
                  }
                }
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                if (maxValue == null || value < maxValue) {
                  // Usiamo step per l'incremento
                  final newValue = value + step;
                  // Assicuriamoci di non superare il massimo
                  if (maxValue == null || newValue <= maxValue) {
                    onChanged(newValue);
                  } else {
                    onChanged(maxValue);
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
