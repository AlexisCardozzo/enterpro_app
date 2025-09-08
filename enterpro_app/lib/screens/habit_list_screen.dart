import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enterpro_app/providers/habit_provider.dart';
import 'package:enterpro_app/models/habit.dart';
import 'package:enterpro_app/screens/add_habit_screen.dart';
import 'package:enterpro_app/screens/gamification_screen.dart';
import 'package:enterpro_app/providers/gamification_provider.dart';

class HabitListScreen extends StatelessWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: ListView.builder(
        itemCount: habitProvider.habits.length,
        itemBuilder: (context, index) {
          final habit = habitProvider.habits[index];
          return ListTile(
            title: Text(habit.name),
            subtitle: Text(habit.description),
            trailing: Checkbox(
              value: habit.isCompletedToday,
              onChanged: (bool? value) {
                habitProvider.toggleHabitCompletion(habit);
                if (value == true) {
                  Provider.of<GamificationProvider>(context, listen: false).addPoints(10); // Example: 10 points per habit
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