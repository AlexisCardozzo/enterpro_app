class Avatar {
  final int id;
  final String head;
  final String body;
  final String accessory;

  Avatar({
    required this.id,
    required this.head,
    required this.body,
    required this.accessory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'head': head,
      'body': body,
      'accessory': accessory,
    };
  }

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      id: map['id'] as int,
      head: map['head'] as String,
      body: map['body'] as String,
      accessory: map['accessory'] as String,
    );
  }

  Avatar copyWith({
    int? id,
    String? head,
    String? body,
    String? accessory,
  }) {
    return Avatar(
      id: id ?? this.id,
      head: head ?? this.head,
      body: body ?? this.body,
      accessory: accessory ?? this.accessory,
    );
  }
}