import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/database_helper.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];


  final DatabaseHelper _dbHelper;

  List<Habit> get habits => _habits;

  HabitProvider({DatabaseHelper? dbHelper}) : _dbHelper = dbHelper ?? DatabaseHelper.instance {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    _habits = await _dbHelper.getHabits();
    notifyListeners();
  }



  Future<void> addHabit(Habit habit) async {
    await DatabaseHelper.instance.insertHabit(habit);
    _habits.add(habit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await _dbHelper.updateHabit(habit);
    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    await DatabaseHelper.instance.deleteHabit(habit.id);
    _habits.removeWhere((h) => h.id == habit.id);
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    final updatedHabit = habit.copyWith(
      isCompletedToday: !habit.isCompletedToday,
      streak: habit.isCompletedToday ? habit.streak - 1 : habit.streak + 1,
    );
    await _dbHelper.updateHabit(updatedHabit);
    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }
}