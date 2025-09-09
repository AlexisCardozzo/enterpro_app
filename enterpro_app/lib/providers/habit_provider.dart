import 'package:flutter/material.dart';
import 'package:enterpro/models/habit.dart';
import 'package:enterpro/repositories/habit_repository.dart';
import 'package:enterpro/services/database_helper.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];


  final HabitRepository _habitRepository;

  List<Habit> get habits => _habits;

  HabitProvider({HabitRepository? habitRepository}) : _habitRepository = habitRepository ?? HabitRepository(DatabaseHelper.instance) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    _habits = await _habitRepository.getHabits();
    notifyListeners();
  }



  Future<void> addHabit(Habit habit) async {
    await _habitRepository.insertHabit(habit);
    _habits.add(habit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitRepository.updateHabit(habit);
    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    await _habitRepository.deleteHabit(habit.id);
    _habits.removeWhere((h) => h.id == habit.id);
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    final updatedHabit = habit.copyWith(
      isCompletedToday: !habit.isCompletedToday,
      streak: habit.isCompletedToday ? habit.streak - 1 : habit.streak + 1,
    );
    await _habitRepository.updateHabit(updatedHabit);
    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }
}