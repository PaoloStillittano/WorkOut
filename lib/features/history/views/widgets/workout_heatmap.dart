import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutHeatmap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final Color primaryColor;
  final Function(DateTime)? onTap;

  const WorkoutHeatmap({
    super.key,
    required this.datasets,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Get last 12 weeks of data
    final today = DateTime.now();
    final weeks = <List<DateTime>>[];
    
    for (int weekIndex = 11; weekIndex >= 0; weekIndex--) {
      final week = <DateTime>[];
      for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
        final date = today.subtract(Duration(days: weekIndex * 7 + (6 - dayIndex)));
        week.add(DateTime(date.year, date.month, date.day));
      }
      weeks.add(week);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day labels
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((day) => SizedBox(
                      width: 32,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        
        // Heatmap grid
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: weeks.length,
            itemBuilder: (context, weekIndex) {
              final week = weeks[weekIndex];
              final weekStart = week.first;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    // Week label
                    SizedBox(
                      width: 36,
                      child: Text(
                        DateFormat('MMM d').format(weekStart),
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    
                    // Day cells
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: week.map((date) {
                          final intensity = datasets[date] ?? 0;
                          final hasWorkout = intensity > 0;
                          
                          return GestureDetector(
                            onTap: () => onTap?.call(date),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: hasWorkout
                                    ? primaryColor.withOpacity(_getOpacity(intensity))
                                    : colorScheme.surfaceVariant.withAlpha(100),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withAlpha(50),
                                  width: 1,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Less',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            ...List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: index == 0
                        ? colorScheme.surfaceVariant.withAlpha(100)
                        : primaryColor.withOpacity(0.2 + (index * 0.2)),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withAlpha(50),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(width: 8),
            Text(
              'More',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _getOpacity(int intensity) {
    if (intensity == 0) return 0.0;
    if (intensity < 50) return 0.3;
    if (intensity < 100) return 0.5;
    if (intensity < 150) return 0.7;
    return 1.0;
  }
}
