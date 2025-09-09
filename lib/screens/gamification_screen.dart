/// Pantalla que muestra las estadísticas de gamificación del usuario,
/// incluyendo EnterCoins, nivel actual y logros desbloqueados.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enterpro/providers/gamification_provider.dart';

class GamificationScreen extends StatelessWidget {
  /// Constructor para `GamificationScreen`.
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene la instancia de GamificationProvider del árbol de widgets.
    final gamificationProvider = Provider.of<GamificationProvider>(context);
    // Obtiene las estadísticas del usuario.
    final userStats = gamificationProvider.userStats;
    // Encuentra el nivel actual del usuario.
    final currentLevel = gamificationProvider.levels.firstWhere(
      (level) => level.id == userStats.currentLevelId,
      orElse: () => gamificationProvider.levels.first, // Por defecto, el primer nivel si no se encuentra.
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Gamificación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Muestra los EnterCoins del usuario.
            Text('EnterCoins: ${userStats.enterCoins}', style: const TextStyle(fontSize: 20)),
            // Muestra el nivel actual del usuario.
            Text('Nivel Actual: ${currentLevel.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            // Título para la sección de logros.
            const Text('Logros:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            // Lista expandible de logros.
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