import 'package:flutter/material.dart';

class WorkoutTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const WorkoutTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withAlpha(40),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: selectedType == 'Push'
                      ? LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withAlpha(200),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: selectedType != 'Push'
                      ? colorScheme.surface.withAlpha(100)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.arrow_upward,
                    size: 24,
                    color: selectedType == 'Push'
                        ? Colors.white
                        : colorScheme.onSurface,
                  ),
                  label: Text(
                    'Push',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: selectedType == 'Push'
                          ? Colors.white
                          : colorScheme.onSurface,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => onTypeChanged('Push'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: selectedType == 'Pull'
                      ? LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withAlpha(200),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: selectedType != 'Pull'
                      ? colorScheme.surface.withAlpha(100)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.arrow_downward,
                    size: 24,
                    color: selectedType == 'Pull'
                        ? Colors.white
                        : colorScheme.onSurface,
                  ),
                  label: Text(
                    'Pull',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: selectedType == 'Pull'
                          ? Colors.white
                          : colorScheme.onSurface,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => onTypeChanged('Pull'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}