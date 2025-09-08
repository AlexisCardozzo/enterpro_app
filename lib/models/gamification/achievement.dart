class Achievement {
  final int id;
  final String name;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedDate;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.isUnlocked = false,
    this.unlockedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isUnlocked': isUnlocked ? 1 : 0,
      'unlockedDate': unlockedDate?.toIso8601String(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isUnlocked: map['isUnlocked'] == 1,
      unlockedDate: map['unlockedDate'] != null
          ? DateTime.parse(map['unlockedDate'])
          : null,
    );
  }

  Achievement copyWith({
    int? id,
    String? name,
    String? description,
    bool? isUnlocked,
    DateTime? unlockedDate,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
    );
  }
}