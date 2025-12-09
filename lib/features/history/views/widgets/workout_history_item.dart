import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout/core/utils/time_formatter.dart';
import '../../data/models/workout_session.dart';

class WorkoutHistoryItem extends StatefulWidget {
  final WorkoutSession session;
  final Function(String) onDelete;

  const WorkoutHistoryItem({
    super.key,
    required this.session,
    required this.onDelete,
  });

  @override
  State<WorkoutHistoryItem> createState() => _WorkoutHistoryItemState();
}

class _WorkoutHistoryItemState extends State<WorkoutHistoryItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPush = widget.session.workoutType == 'Push';
    final themeColor = isPush ? Colors.orange : Colors.blue;

    return Dismissible(
      key: Key(widget.session.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Workout'),
              content: const Text('Are you sure you want to delete this workout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        widget.onDelete(widget.session.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withAlpha(50),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: themeColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isPush ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          color: themeColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Main Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.session.workoutType} Workout',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.yMMMd().add_jm().format(widget.session.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Stats
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildStatRow(
                            Icons.timer_outlined,
                            TimeFormatter.formatSeconds(widget.session.durationSeconds),
                            colorScheme,
                          ),
                          const SizedBox(height: 4),
                          _buildStatRow(
                            Icons.repeat,
                            '${widget.session.totalReps} reps',
                            colorScheme,
                          ),
                        ],
                      ),

                      // Expand icon
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  
                  // Expanded details
                  if (_isExpanded) ...[
                    const SizedBox(height: 16),
                    Divider(color: colorScheme.outlineVariant.withAlpha(50)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailItem(
                          'Sets',
                          widget.session.totalSets.toString(),
                          Icons.fitness_center,
                          colorScheme,
                        ),
                        _buildDetailItem(
                          'Series',
                          widget.session.totalSeries.toString(),
                          Icons.repeat_one,
                          colorScheme,
                        ),
                        _buildDetailItem(
                          'Duration',
                          TimeFormatter.formatSeconds(widget.session.durationSeconds),
                          Icons.timer,
                          colorScheme,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String text, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, ColorScheme colorScheme) {
    return Column(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
