/// Representa un avatar personalizable con diferentes partes.
class Avatar {
  /// Identificador único del avatar.
  final int id;
  /// La parte de la cabeza del avatar.
  final String head;
  /// La parte del cuerpo del avatar.
  final String body;
  /// El accesorio del avatar.
  final String accessory;

  /// Constructor para crear una instancia de [Avatar].
  Avatar({
    required this.id,
    required this.head,
    required this.body,
    required this.accessory,
  });

  /// Convierte una instancia de [Avatar] en un mapa para almacenamiento en base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'head': head,
      'body': body,
      'accessory': accessory,
    };
  }

  /// Crea una instancia de [Avatar] a partir de un mapa (usado para cargar desde la base de datos).
  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      id: map['id'] as int,
      head: map['head'] as String,
      body: map['body'] as String,
      accessory: map['accessory'] as String,
    );
  }

  /// Crea una copia de esta instancia de [Avatar] con valores opcionales modificados.
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