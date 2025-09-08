import 'package:flutter/material.dart';
import 'package:enterpro_app/models/gamification/achievement.dart';
import 'package:enterpro_app/models/gamification/level.dart';
import 'package:enterpro_app/models/gamification/user_stats.dart';
import 'package:enterpro_app/services/database_helper.dart';

class GamificationProvider with ChangeNotifier {
  UserStats _userStats = UserStats(id: 1);
  final List<Level> _levels = [
    Level(id: 1, name: 'Beginner', requiredPoints: 0),
    Level(id: 2, name: 'Apprentice', requiredPoints: 100),
    Level(id: 3, name: 'Journeyman', requiredPoints: 250),
    Level(id: 4, name: 'Master', requiredPoints: 500),
    Level(id: 5, name: 'Grandmaster', requiredPoints: 1000),
  ];
  List<Achievement> _achievements = [
    Achievement(id: 1, name: 'First Step', description: 'Complete your first habit.'),
    Achievement(id: 2, name: 'Streak Starter', description: 'Achieve a 3-day habit streak.'),
    Achievement(id: 3, name: 'Habit Master', description: 'Complete 10 habits.'),
  ];

  GamificationProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _userStats = await DatabaseHelper.instance.getUserStats() ?? UserStats(id: 1);
    _achievements = await DatabaseHelper.instance.getAchievements();
    if (_achievements.isEmpty) {
      for (var achievement in _achievements) {
        await DatabaseHelper.instance.insertAchievement(achievement);
      }
    }
    notifyListeners();
  }

  UserStats get userStats => _userStats;
  List<Level> get levels => _levels;
  List<Achievement> get achievements => _achievements;

  Future<void> addPoints(int points) async {
    _userStats = _userStats.copyWith(currentPoints: _userStats.currentPoints + points);
    await DatabaseHelper.instance.updateUserStats(_userStats);
    _checkLevelUp();
    await _checkAchievements();
    notifyListeners();
  }

  void _checkLevelUp() {
    for (var level in _levels) {
      if (_userStats.currentPoints >= level.requiredPoints && _userStats.currentLevelId < level.id) {
        _userStats = _userStats.copyWith(currentLevelId: level.id);
        // Optionally, add a notification or animation for level up
      }
    }
  }

  Future<void> _checkAchievements() async {
    // Example: Unlock 'First Step' achievement
    if (_userStats.currentPoints >= 10 && !_achievements[0].isUnlocked) { // Assuming 'First Step' is the first achievement
      _achievements[0] = _achievements[0].copyWith(isUnlocked: true, unlockedDate: DateTime.now());
      await DatabaseHelper.instance.updateAchievement(_achievements[0]);
    }
    // More complex achievement logic would go here
  }
}