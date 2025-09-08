import 'package:flutter/material.dart';
import 'package:enterpro/models/math_game.dart';
import 'package:enterpro/services/database_helper.dart';
import 'package:enterpro/screens/math_play_game_screen.dart';
import 'package:enterpro/models/math_question.dart';

class MathGameListScreen extends StatefulWidget {
  const MathGameListScreen({Key? key}) : super(key: key);

  @override
  State<MathGameListScreen> createState() => _MathGameListScreenState();
}

class _MathGameListScreenState extends State<MathGameListScreen> {
  late Future<List<MathGame>> _mathGamesFuture;

  @override
  void initState() {
    super.initState();
    _mathGamesFuture = DatabaseHelper().getMathGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos de Matemáticas'),
      ),
      body: FutureBuilder<List<MathGame>>(
        future: _mathGamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay juegos de matemáticas disponibles.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final game = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(game.name),
                    subtitle: Text(game.description),
                    trailing: Text(game.difficulty),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MathPlayGameScreen(game: game),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example: Add a sample math game for testing
          final newGame = MathGame(
            id: DateTime.now().millisecondsSinceEpoch,
            name: 'Suma Fácil',
            description: 'Juego de sumas básicas para principiantes.',
            difficulty: 'Fácil',
          );
          await DatabaseHelper().insertMathGame(newGame);

          // Example: Add some questions for the sample game
          await DatabaseHelper().insertMathQuestion(MathQuestion(
            id: DateTime.now().millisecondsSinceEpoch + 1,
            gameId: newGame.id,
            question: '2 + 2 = ?',
            options: ['3', '4', '5', '6'],
            correctAnswer: '4',
          ));
          await DatabaseHelper().insertMathQuestion(MathQuestion(
            id: DateTime.now().millisecondsSinceEpoch + 2,
            gameId: newGame.id,
            question: '5 + 3 = ?',
            options: ['7', '8', '9', '10'],
            correctAnswer: '8',
          ));

          setState(() {
            _mathGamesFuture = DatabaseHelper().getMathGames(); // Refresh the list
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Juego de matemáticas de ejemplo añadido.')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}