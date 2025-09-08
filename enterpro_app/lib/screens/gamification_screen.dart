import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enterpro_app/providers/gamification_provider.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamificationProvider = Provider.of<GamificationProvider>(context);
    final userStats = gamificationProvider.userStats;
    final currentLevel = gamificationProvider.levels.firstWhere(
      (level) => level.id == userStats.currentLevelId,
      orElse: () => gamificationProvider.levels.first, // Default to first level if not found
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamification Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Current Points: ${userStats.currentPoints}', style: const TextStyle(fontSize: 20)),
            Text('Current Level: ${currentLevel.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Achievements:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: gamificationProvider.achievements.length,
                itemBuilder: (context, index) {
                  final achievement = gamificationProvider.achievements[index];
                  return ListTile(
                    title: Text(achievement.name),
                    subtitle: Text(achievement.description),
                    trailing: achievement.isUnlocked
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.lock, color: Colors.grey),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}