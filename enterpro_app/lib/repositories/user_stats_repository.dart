import 'package:enterpro/models/gamification/user_stats.dart';
import 'package:enterpro/services/database_helper.dart';

class UserStatsRepository {
  final DatabaseHelper _databaseHelper;

  UserStatsRepository(this._databaseHelper);

  Future<UserStats?> getUserStats() async {
    return await _databaseHelper.getUserStats();
  }

  Future<void> insertUserStats(UserStats stats) async {
    await _databaseHelper.insertUserStats(stats);
  }

  Future<void> updateUserStats(UserStats stats) async {
    await _databaseHelper.updateUserStats(stats);
  }
}