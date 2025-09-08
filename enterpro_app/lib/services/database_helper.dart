import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:enterpro_app/models/habit.dart';
import 'package:enterpro_app/models/gamification/user_stats.dart';
import 'package:enterpro_app/models/gamification/achievement.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'enterpro_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE habits(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        creationDate TEXT,
        streak INTEGER,
        isCompletedToday INTEGER
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE user_stats(
        id INTEGER PRIMARY KEY,
        currentPoints INTEGER,
        currentLevelId INTEGER
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE achievements(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        isUnlocked INTEGER,
        unlockedDate TEXT
      )
      '''
    );
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  Future<UserStats?> getUserStats() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_stats');
    if (maps.isNotEmpty) {
      return UserStats.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> insertUserStats(UserStats stats) async {
    final db = await database;
    await db.insert('user_stats', stats.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateUserStats(UserStats stats) async {
    final db = await database;
    await db.update(
      'user_stats',
      stats.toMap(),
      where: 'id = ?',
      whereArgs: [stats.id],
    );
  }

  Future<List<Achievement>> getAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');
    return List.generate(maps.length, (i) {
      return Achievement.fromMap(maps[i]);
    });
  }

  Future<void> insertAchievement(Achievement achievement) async {
    final db = await database;
    await db.insert('achievements', achievement.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateAchievement(Achievement achievement) async {
    final db = await database;
    await db.update(
      'achievements',
      achievement.toMap(),
      where: 'id = ?',
      whereArgs: [achievement.id],
    );
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(String id) async {
    final db = await database;
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}