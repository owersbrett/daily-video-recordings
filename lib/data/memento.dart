// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Memento {
    static const String tableName = "Memento";

  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "userId INTEGER",
    "originalStringValue TEXT",
    "stringValue TEXT",
    "createdAt INTEGER",
    "updatedAt INTEGER"
  ];
  final int? id;
  final int userId;
  final String originalStringValue;
  final String stringValue;
  final DateTime createDate;
  final DateTime updateDate;

  Memento({
    this.id,
    required this.userId,
    required this.originalStringValue,
    required this.stringValue,
    required this.createDate,
    required this.updateDate,
  });

  Memento copyWith({
    int? id,
    int? userId,
    String? originalStringValue,
    String? stringValue,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return Memento(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      originalStringValue: originalStringValue ?? this.originalStringValue,
      stringValue: stringValue ?? this.stringValue,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'originalStringValue': originalStringValue,
      'stringValue': stringValue,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory Memento.fromMap(Map<String, dynamic> map) {
    return Memento(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] as int,
      originalStringValue: map['originalStringValue'] as String,
      stringValue: map['stringValue'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Memento.fromJson(String source) => Memento.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Memento(id: $id, userId: $userId, originalStringValue: $originalStringValue, stringValue: $stringValue, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant Memento other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.originalStringValue == originalStringValue &&
      other.stringValue == stringValue &&
      other.createDate == createDate &&
      other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      originalStringValue.hashCode ^
      stringValue.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode;
  }
}
