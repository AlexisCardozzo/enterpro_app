class MathGame {
  final int id;
  final String name;
  final String description;
  final String difficulty;

  MathGame({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
    };
  }

  factory MathGame.fromMap(Map<String, dynamic> map) {
    return MathGame(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      difficulty: map['difficulty'],
    );
  }
}