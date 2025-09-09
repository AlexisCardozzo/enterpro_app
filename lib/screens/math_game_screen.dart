import 'package:flutter/material.dart';
import 'package:enterpro/screens/math_game_list_screen.dart';

class MathGameScreen extends StatelessWidget {
  const MathGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mundo Matemágico'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido al Mundo Matemágico!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MathGameListScreen(),
                  ),
                );
              },
              child: const Text('Empezar Juego de Matemáticas'),
            ),
          ],
        ),
      ),
    );
  }
}