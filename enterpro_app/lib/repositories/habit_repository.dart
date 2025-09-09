import 'package:enterpro/models/habit.dart';
import 'package:enterpro/services/database_helper.dart';

class HabitRepository {
  final DatabaseHelper _databaseHelper;

  HabitRepository(this._databaseHelper);

  Future<void> insertHabit(Habit habit) async {
    await _databaseHelper.insertHabit(habit);
  }

  Future<List<Habit>> getHabits() async {
    return await _databaseHelper.getHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _databaseHelper.updateHabit(habit);
  }

  Future<void> deleteHabit(String id) async {
    await _databaseHelper.deleteHabit(id);
  }
}