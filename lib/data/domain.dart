// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Domain {

  static String tableName = "Domain";

  static List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "name TEXT",
    "description TEXT"
  ];

  final int id;
  final String name;
  final String description;
  Domain({
    required this.id,
    required this.name,
    required this.description,
  });

  Domain copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Domain(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Domain.fromMap(Map<String, dynamic> map) {
    return Domain(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Domain.fromJson(String source) => Domain.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Domain(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(covariant Domain other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}

Domain body = Domain(
  id: 3,
  name: 'Body',
  description: 'Physical health',
);
Domain mind = Domain(
  id: 2,
  name: 'Mind',
  description: 'Mental health',
);
Domain spirit = Domain(
  id: 1,
  name: 'Spirit',
  description: 'Spiritual health',
);
Domain discipline = Domain(
  id: 0,
  name: 'Discipline',
  description: 'Discipline',
);