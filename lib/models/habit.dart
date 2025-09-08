class Habit {
  final String id;
  final String name;
  final String description;
  final DateTime creationDate;
  final int streak;
  final bool isCompletedToday;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.creationDate,
    this.streak = 0,
    this.isCompletedToday = false,
  });

  // Convert a Habit object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creationDate': creationDate.toIso8601String(),
      'streak': streak,
      'isCompletedToday': isCompletedToday ? 1 : 0,
    };
  }

  // Extract a Habit object from a Map object
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      creationDate: DateTime.parse(map['creationDate']),
      streak: map['streak'],
      isCompletedToday: map['isCompletedToday'] == 1,
    );
  }

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? creationDate,
    int? streak,
    bool? isCompletedToday,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
      streak: streak ?? this.streak,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }
}