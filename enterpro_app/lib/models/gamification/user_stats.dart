class UserStats {
  final int id;
  final int currentPoints;
  final int currentLevelId;

  UserStats({
    required this.id,
    this.currentPoints = 0,
    this.currentLevelId = 1, // Assuming level 1 is the starting level
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentPoints': currentPoints,
      'currentLevelId': currentLevelId,
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      id: map['id'],
      currentPoints: map['currentPoints'],
      currentLevelId: map['currentLevelId'],
    );
  }

  UserStats copyWith({
    int? id,
    int? currentPoints,
    int? currentLevelId,
  }) {
    return UserStats(
      id: id ?? this.id,
      currentPoints: currentPoints ?? this.currentPoints,
      currentLevelId: currentLevelId ?? this.currentLevelId,
    );
  }
}