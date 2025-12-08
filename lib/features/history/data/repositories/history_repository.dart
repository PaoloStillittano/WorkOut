import 'package:hive/hive.dart';
import '../models/workout_session.dart';

class HistoryRepository {
  static const String boxName = 'workout_sessions';

  Future<Box<WorkoutSession>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<WorkoutSession>(boxName);
    }
    return await Hive.openBox<WorkoutSession>(boxName);
  }

  Future<void> saveSession(WorkoutSession session) async {
    final box = await _getBox();
    await box.put(session.id, session);
  }

  Future<List<WorkoutSession>> getAllSessions() async {
    final box = await _getBox();
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> deleteSession(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
