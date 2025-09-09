class UserStats {
  final int id;
  final int enterCoins;
  final int currentLevelId;

  UserStats({
    required this.id,
    this.enterCoins = 0,
    this.currentLevelId = 1, // Assuming level 1 is the starting level
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enterCoins': enterCoins,
      'currentLevelId': currentLevelId,
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      id: map['id'],
      enterCoins: map['enterCoins'],
      currentLevelId: map['currentLevelId'],
    );
  }

  UserStats copyWith({
    int? id,
    int? enterCoins,
    int? currentLevelId,
  }) {
    return UserStats(
      id: id ?? this.id,
      enterCoins: enterCoins ?? this.enterCoins,
      currentLevelId: currentLevelId ?? this.currentLevelId,
    );
  }
}