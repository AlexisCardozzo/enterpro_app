class MathQuestion {
  final int id;
  final int gameId;
  final String question;
  final List<String> options;
  final String correctAnswer;

  MathQuestion({
    required this.id,
    required this.gameId,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameId': gameId,
      'question': question,
      'options': options.join(','), // Store as comma-separated string
      'correctAnswer': correctAnswer,
    };
  }

  factory MathQuestion.fromMap(Map<String, dynamic> map) {
    return MathQuestion(
      id: map['id'],
      gameId: map['gameId'],
      question: map['question'],
      options: (map['options'] as String).split(','), // Convert back to list
      correctAnswer: map['correctAnswer'],
    );
  }
}