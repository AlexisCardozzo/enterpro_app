import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enterpro/providers/habit_provider.dart';
import 'package:enterpro/providers/gamification_provider.dart';
import 'package:enterpro/screens/habit_list_screen.dart';
import 'package:enterpro/screens/math_game_screen.dart';
import 'package:enterpro/screens/avatar_customization_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitProvider()),
        ChangeNotifierProvider(create: (context) => GamificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnterPro',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HabitListScreen(),
      routes: {
        '/math_game': (context) => MathGameScreen(),
        '/avatar_customization': (context) => AvatarCustomizationScreen(),
      },
    );
  }
}
