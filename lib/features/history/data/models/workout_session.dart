import 'package:hive/hive.dart';

part 'workout_session.g.dart';

@HiveType(typeId: 0)
class WorkoutSession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String workoutType; // "Push" or "Pull"

  @HiveField(3)
  final int durationSeconds;

  @HiveField(4)
  final int totalSets;

  @HiveField(5)
  final int totalSeries;

  @HiveField(6)
  final int totalReps;

  WorkoutSession({
    required this.id,
    required this.date,
    required this.workoutType,
    required this.durationSeconds,
    required this.totalSets,
    required this.totalSeries,
    required this.totalReps,
  });
}
