/// Este es el punto de entrada principal de la aplicación EnterPro.
/// Configura los proveedores de estado y define la estructura general de la aplicación.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enterpro/providers/habit_provider.dart';
import 'package:enterpro/providers/gamification_provider.dart';
import 'package:enterpro/repositories/achievement_repository.dart';
import 'package:enterpro/repositories/user_stats_repository.dart';
import 'package:enterpro/services/database_helper.dart';
import 'package:enterpro/screens/habit_list_screen.dart';
import 'package:enterpro/screens/math_game_screen.dart';
import 'package:enterpro/screens/avatar_customization_screen.dart';

void main() {
  // Ejecuta la aplicación, envolviéndola en un MultiProvider para la gestión de estado.
  runApp(
    MultiProvider(
      providers: [
        // Provee el HabitProvider a todo el árbol de widgets.
        ChangeNotifierProvider(create: (context) => HabitProvider()),
        // Provee el GamificationProvider a todo el árbol de widgets.
        ChangeNotifierProvider(
          create: (context) => GamificationProvider(
            userStatsRepository: UserStatsRepository(DatabaseHelper.instance),
            achievementRepository: AchievementRepository(DatabaseHelper.instance),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// `MyApp` es el widget raíz de la aplicación.
/// Define la configuración del tema, la pantalla de inicio y las rutas de navegación.
class MyApp extends StatelessWidget {
  /// Constructor para `MyApp`.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnterPro',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define la pantalla de inicio de la aplicación.
      home: const HabitListScreen(),
      // Define las rutas de navegación de la aplicación.
      routes: {
        '/math_game': (context) => MathGameScreen(),
        '/avatar_customization': (context) => AvatarCustomizationScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
