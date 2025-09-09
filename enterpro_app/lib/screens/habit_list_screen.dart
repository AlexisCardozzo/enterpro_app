import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enterpro/providers/habit_provider.dart';
import 'package:enterpro/models/habit.dart';
import 'package:enterpro/screens/add_habit_screen.dart';
import 'package:enterpro/screens/gamification_screen.dart';
import 'package:enterpro/providers/gamification_provider.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger( // Wrap with ScaffoldMessenger
      key: _scaffoldMessengerKey,
      child: Scaffold(
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GamificationScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.face),
            onPressed: () {
              Navigator.of(context).pushNamed('/avatar_customization');
            },
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              Navigator.of(context).pushNamed('/math_game');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: habitProvider.habits.length,
        itemBuilder: (context, index) {
          final habit = habitProvider.habits[index];
          return AnimatedOpacity(
            opacity: habit.isCompletedToday ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 500),
            child: ListTile(
              title: Text(habit.name),
              subtitle: Text(habit.description),
              trailing: Checkbox(
                value: habit.isCompletedToday,
                onChanged: (bool? value) {
                  habitProvider.toggleHabitCompletion(habit);
                  if (value == true) {
                    Provider.of<GamificationProvider>(context, listen: false).addEnterCoins(10); // Example: 10 points per habit
                    _scaffoldMessengerKey.currentState?.showSnackBar(
                      SnackBar(
                        content: Text('¡Hábito "${habit.name}" completado! +10 EnterCoins'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              onTap: () {
                // TODO: Implement habit detail/edit screen
              },
              onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Habit'),
                  content: Text('Are you sure you want to delete ${habit.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        habitProvider.deleteHabit(habit);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}