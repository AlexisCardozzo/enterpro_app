import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enterpro_app/providers/habit_provider.dart';
import 'package:enterpro_app/providers/gamification_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GamificationProvider()),
        ],
        child: MyApp(),
      ),
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
      home: HabitListScreen(),
    );
  }
}
