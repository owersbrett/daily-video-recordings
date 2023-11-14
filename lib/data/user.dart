// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
static const String tableName = "User";
static const List<String> columnDeclarations = [
  "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
  "name TEXT",
  "createDate INTEGER",
  "updateDate INTEGER"
];

  final int id;
  final String name;
  final DateTime createDate;
  final DateTime updateDate;
  User({
    required this.id,
    required this.name,
    required this.createDate,
    required this.updateDate,
  });


  User copyWith({
    int? id,
    String? name,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.createDate == createDate &&
      other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode;
  }
}
