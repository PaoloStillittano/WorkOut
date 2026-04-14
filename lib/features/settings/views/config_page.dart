import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Configurazione', style: AppTypography.headlineMedium),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer2<SettingsViewModel, ThemeProvider>(
        builder: (context, settingsViewModel, themeProvider, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Impostazioni Allenamento',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: AppDimensions.p24),

                // Set Configuration
                _buildNumberInput(
                  label: 'Numero di Set',
                  value: settingsViewModel.totalSets,
                  onChanged: settingsViewModel.updateTotalSets,
                  minValue: 1,
                ),

                const SizedBox(height: AppDimensions.p16),

                // Series Configuration
                _buildNumberInput(
                  label: 'Serie per Set',
                  value: settingsViewModel.seriesPerSet,
                  onChanged: settingsViewModel.updateSeriesPerSet,
                  minValue: 1,
                ),

                const SizedBox(height: AppDimensions.p16),

                // Reps Configuration
                _buildNumberInput(
                  label: 'Ripetizioni per Serie',
                  value: settingsViewModel.repsPerSeries,
                  onChanged: settingsViewModel.updateRepsPerSeries,
                  minValue: 1,
                  maxValue: 40,
                  helperText:
                      'Questo valore determina sia il numero di ripetizioni per serie che l\'incremento quando premi + o -',
                ),

                const SizedBox(height: AppDimensions.p16),

                // Rest Time Configuration
                _buildNumberInput(
                  label: 'Tempo di Recupero (secondi)',
                  value: settingsViewModel.restTimeSeconds,
                  onChanged: settingsViewModel.updateRestTimeSeconds,
                  minValue: 5,
                  step: 5,
                ),

                const SizedBox(height: AppDimensions.p32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.save,
                      size: AppDimensions.iconMedium,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Salva Configurazione',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radius12),
                      ),
                    ),
                    onPressed: () async {
                      await settingsViewModel.saveConfig();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
           ),
          ),
        );
      },
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      padding: const EdgeInsets.all(AppDimensions.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelLarge,
          ),
          if (helperText != null) ...[
            const SizedBox(height: AppDimensions.p4),
            Text(
              helperText,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.p16),
          Row(
            children: [
              _buildRoundButton(Icons.remove, () {
                if (value > (minValue ?? 1)) {
                  final newValue = value - step;
                  if (newValue >= (minValue ?? 1)) {
                    onChanged(newValue);
                  } else {
                    onChanged(minValue ?? 1);
                  }
                }
              }),
              Expanded(
                child: Center(
                  child: Text(
                    value.toString(),
                    style: AppTypography.headlineMedium,
                  ),
                ),
              ),
              _buildRoundButton(Icons.add, () {
                if (maxValue == null || value < maxValue) {
                  final newValue = value + step;
                  if (maxValue == null || newValue <= maxValue) {
                    onChanged(newValue);
                  } else {
                    onChanged(maxValue);
                  }
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: AppColors.cardBackgroundLight,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.p12),
          child: Icon(
            icon,
            size: AppDimensions.iconMedium,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

