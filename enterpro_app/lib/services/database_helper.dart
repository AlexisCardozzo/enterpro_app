import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:enterpro/models/habit.dart';
import 'package:enterpro/models/gamification/user_stats.dart';
import 'package:enterpro/models/gamification/achievement.dart';
import 'package:enterpro/models/math_game.dart';
import 'package:enterpro/models/math_question.dart';
import 'package:enterpro/models/avatar.dart';

class DatabaseHelper {
  static Database? _database;
  Database? _testDatabase;

  DatabaseHelper({Database? testDatabase}) : _testDatabase = testDatabase;

  static final DatabaseHelper instance = DatabaseHelper();

  Future<Database> get database async {
    if (_testDatabase != null) return _testDatabase!;
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
        enterCoins INTEGER,
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
    await db.execute(
      '''
      CREATE TABLE math_games(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        difficulty TEXT
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE math_questions(
        id INTEGER PRIMARY KEY,
        gameId INTEGER,
        question TEXT,
        options TEXT,
        correctAnswer TEXT
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

  Future<void> insertMathGame(MathGame game) async {
    final db = await database;
    await db.insert(
      'math_games',
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MathGame>> getMathGames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('math_games');
    return List.generate(maps.length, (i) {
      return MathGame.fromMap(maps[i]);
    });
  }

  Future<void> updateMathGame(MathGame game) async {
    final db = await database;
    await db.update(
      'math_games',
      game.toMap(),
      where: 'id = ?',
      whereArgs: [game.id],
    );
  }

  Future<void> deleteMathGame(int id) async {
    final db = await database;
    await db.delete(
      'math_games',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertMathQuestion(MathQuestion question) async {
    final db = await database;
    await db.insert(
      'math_questions',
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Avatar CRUD operations
  Future<int> insertAvatar(Avatar avatar) async {
    final db = await database;
    return await db.insert('avatars', avatar.toMap());
  }

  Future<Avatar?> getAvatar(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'avatars',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Avatar.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateAvatar(Avatar avatar) async {
    final db = await database;
    return await db.update(
      'avatars',
      avatar.toMap(),
      where: 'id = ?',
      whereArgs: [avatar.id],
    );
  }

  Future<int> deleteAvatar(int id) async {
    final db = await database;
    return await db.delete(
      'avatars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<MathQuestion>> getMathQuestionsForGame(int gameId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'math_questions',
      where: 'gameId = ?',
      whereArgs: [gameId],
    );
    return List.generate(maps.length, (i) {
      return MathQuestion.fromMap(maps[i]);
    });
  }

  Future<void> updateMathQuestion(MathQuestion question) async {
    final db = await database;
    await db.update(
      'math_questions',
      question.toMap(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<void> deleteMathQuestion(int id) async {
    final db = await database;
    await db.delete(
      'math_questions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}