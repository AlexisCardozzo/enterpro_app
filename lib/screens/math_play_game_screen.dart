import 'package:flutter/material.dart';
import 'package:enterpro/models/math_game.dart';
import 'package:enterpro/models/math_question.dart';
import 'package:enterpro/services/database_helper.dart';
import 'package:enterpro/providers/gamification_provider.dart';
import 'package:provider/provider.dart';

class MathPlayGameScreen extends StatefulWidget {
  final MathGame game;

  const MathPlayGameScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<MathPlayGameScreen> createState() => _MathPlayGameScreenState();
}

class _MathPlayGameScreenState extends State<MathPlayGameScreen> {
  late Future<List<MathQuestion>> _mathQuestionsFuture;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _isAnswerCorrect = false;
  int _correctAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    _mathQuestionsFuture = DatabaseHelper().getMathQuestionsForGame(widget.game.id);
  }

  void _checkAnswer(String selectedAnswer, String correctAnswer) {
    setState(() {
      _selectedAnswer = selectedAnswer;
      _isAnswerCorrect = (selectedAnswer == correctAnswer);
      if (_isAnswerCorrect) {
        _correctAnswersCount++;
        Provider.of<GamificationProvider>(context, listen: false).addEnterCoins(10); // Award 10 EnterCoins per correct answer
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Respuesta correcta! +10 EnterCoins'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  void _nextQuestion(List<MathQuestion> questions) {
    setState(() {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswerCorrect = false;
      } else {
        // Handle end of game
        if (_correctAnswersCount == questions.length) {
          Provider.of<GamificationProvider>(context, listen: false).addEnterCoins(50); // Bonus for all correct answers
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Juego completado con todas las respuestas correctas! +50 EnterCoins de bonus'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        Navigator.pop(context); // Navigate back to the game list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
      ),
      body: FutureBuilder<List<MathQuestion>>(
        future: _mathQuestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay preguntas para este juego.'));
          } else {
            final questions = snapshot.data!;
            if (questions.isEmpty) {
              return const Center(child: Text('No hay preguntas para este juego.'));
            }
            final currentQuestion = questions[_currentQuestionIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Pregunta ${_currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentQuestion.question,
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ...currentQuestion.options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: _selectedAnswer == null
                            ? () => _checkAnswer(option, currentQuestion.correctAnswer)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedAnswer == option
                              ? (_isAnswerCorrect ? Colors.green : Colors.red)
                              : null,
                        ),
                        child: Text(option),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  if (_selectedAnswer != null) ...[
                    Text(
                      _isAnswerCorrect ? '¡Correcto!' : 'Incorrecto. La respuesta correcta era: ${currentQuestion.correctAnswer}',
                      style: TextStyle(
                        color: _isAnswerCorrect ? Colors.green : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _nextQuestion(questions),
                      child: Text(_currentQuestionIndex < questions.length - 1 ? 'Siguiente Pregunta' : 'Terminar Juego'),
                    ),
                  ],
                ],
              ),
            );
          }
        },
      ),
    );
  }
}