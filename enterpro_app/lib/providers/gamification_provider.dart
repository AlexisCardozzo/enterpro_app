/// `GamificationProvider` gestiona la lógica de gamificación de la aplicación,
/// incluyendo las estadísticas del usuario, niveles y logros.
import 'package:flutter/material.dart';
import 'package:enterpro/models/gamification/achievement.dart';
import 'package:enterpro/models/gamification/level.dart';
import 'package:enterpro/models/gamification/user_stats.dart';
import 'package:enterpro/repositories/achievement_repository.dart';
import 'package:enterpro/repositories/user_stats_repository.dart';
import 'package:enterpro/services/database_helper.dart';

class GamificationProvider with ChangeNotifier {
  final UserStatsRepository _userStatsRepository;
  final AchievementRepository _achievementRepository;

  /// Estadísticas actuales del usuario, como monedas y nivel.
  UserStats _userStats = UserStats(id: 1);
  /// Lista predefinida de niveles de gamificación.
  final List<Level> _levels = [
    Level(id: 1, name: 'Beginner', requiredPoints: 0),
    Level(id: 2, name: 'Apprentice', requiredPoints: 100),
    Level(id: 3, name: 'Journeyman', requiredPoints: 250),
    Level(id: 4, name: 'Master', requiredPoints: 500),
    Level(id: 5, name: 'Grandmaster', requiredPoints: 1000),
  ];
  /// Lista de logros del usuario, cargados desde la base de datos.
  List<Achievement> _achievements = [];
  /// Logros predefinidos que se inicializan si la base de datos está vacía.
  final List<Achievement> _predefinedAchievements = [
    Achievement(id: 1, name: 'First Step', description: 'Complete your first habit.'),
    Achievement(id: 2, name: 'Streak Starter', description: 'Achieve a 3-day habit streak.'),
    Achievement(id: 3, name: 'Habit Master', description: 'Complete 10 habits.'),
  ];

  /// Constructor de `GamificationProvider`.
  /// Carga los datos iniciales al instanciar el proveedor.
  GamificationProvider({
    UserStatsRepository? userStatsRepository,
    AchievementRepository? achievementRepository,
  })  : _userStatsRepository = userStatsRepository ?? UserStatsRepository(DatabaseHelper.instance),
        _achievementRepository = achievementRepository ?? AchievementRepository(DatabaseHelper.instance) {
    _loadData();
  }

  /// Carga las estadísticas del usuario y los logros desde la base de datos.
  /// Si no hay logros, inicializa con los logros predefinidos.
  Future<void> _loadData() async {
    _userStats = await _userStatsRepository.getUserStats() ?? UserStats(id: 1);
    _achievements = await _achievementRepository.getAchievements();

    if (_achievements.isEmpty) {
      for (var achievement in _predefinedAchievements) {
        await _achievementRepository.insertAchievement(achievement);
      }
      _achievements = _predefinedAchievements; // Inicializa con los predefinidos si la DB estaba vacía
    }
    notifyListeners();
  }

  /// Getter para las estadísticas del usuario.
  UserStats get userStats => _userStats;
  /// Getter para la lista de niveles.
  List<Level> get levels => _levels;
  /// Getter para la lista de logros.
  List<Achievement> get achievements => _achievements;

  /// Añade monedas al usuario y actualiza sus estadísticas.
  /// También verifica si el usuario sube de nivel y si desbloquea logros.
  Future<void> addEnterCoins(int coins) async {
    _userStats = _userStats.copyWith(enterCoins: _userStats.enterCoins + coins);
    await _userStatsRepository.updateUserStats(_userStats);
    _checkLevelUp();
    await _checkAchievements();
    notifyListeners();
  }

  /// Verifica si el usuario ha alcanzado un nuevo nivel basado en sus `enterCoins`.
  void _checkLevelUp() {
    for (var level in _levels) {
      if (_userStats.enterCoins >= level.requiredPoints && _userStats.currentLevelId < level.id) {
        _userStats = _userStats.copyWith(currentLevelId: level.id);
        // Opcionalmente, añadir una notificación o animación para la subida de nivel
      }
    }
  }

  /// Verifica y desbloquea logros basados en las estadísticas del usuario.
  Future<void> _checkAchievements() async {
    // Ejemplo: Desbloquear el logro 'First Step' (asumiendo que el ID 1 es 'First Step')
    final firstStepAchievement = _achievements.firstWhere((a) => a.id == 1, orElse: () => Achievement(id: 0, name: '', description: ''));
    if (firstStepAchievement.id != 0 && _userStats.enterCoins >= 10 && !firstStepAchievement.isUnlocked) {
      final updatedAchievement = firstStepAchievement.copyWith(isUnlocked: true, unlockedDate: DateTime.now());
      await _achievementRepository.updateAchievement(updatedAchievement);
      // Actualiza el logro en la lista local
      final index = _achievements.indexWhere((a) => a.id == updatedAchievement.id);
      if (index != -1) {
        _achievements[index] = updatedAchievement;
      }
    }
    // La lógica para otros logros más complejos iría aquí
  }
}