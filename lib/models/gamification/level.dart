class Level {
  final int id;
  final String name;
  final int requiredPoints;

  Level({
    required this.id,
    required this.name,
    required this.requiredPoints,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'requiredPoints': requiredPoints,
    };
  }

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      id: map['id'],
      name: map['name'],
      requiredPoints: map['requiredPoints'],
    );
  }

  Level copyWith({
    int? id,
    String? name,
    int? requiredPoints,
  }) {
    return Level(
      id: id ?? this.id,
      name: name ?? this.name,
      requiredPoints: requiredPoints ?? this.requiredPoints,
    );
  }
}