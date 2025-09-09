import 'package:enterpro/models/gamification/achievement.dart';
import 'package:enterpro/services/database_helper.dart';

class AchievementRepository {
  final DatabaseHelper _databaseHelper;

  AchievementRepository(this._databaseHelper);

  Future<List<Achievement>> getAchievements() async {
    return await _databaseHelper.getAchievements();
  }

  Future<void> insertAchievement(Achievement achievement) async {
    await _databaseHelper.insertAchievement(achievement);
  }

  Future<void> updateAchievement(Achievement achievement) async {
    await _databaseHelper.updateAchievement(achievement);
  }
}