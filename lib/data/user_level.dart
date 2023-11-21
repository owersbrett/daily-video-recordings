// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserLevel {

  static String tableName = "UserLevel";

  static List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "userId INTEGER",
    "mindLevelId INTEGER",
    "bodyLevelId INTEGER",
    "spiritLevelId INTEGER",
    "createDate INTEGER",
    "updateDate INTEGER"
  ];


  final int id;
  final int userId;
  final int mindLevelId;
  final int bodyLevelId;
  final int spiritLevelId;
  final DateTime createDate;
  final DateTime updateDate;
  UserLevel({
    required this.id,
    required this.userId,
    required this.mindLevelId,
    required this.bodyLevelId,
    required this.spiritLevelId,
    required this.createDate,
    required this.updateDate,
  });

  UserLevel copyWith({
    int? id,
    int? userId,
    int? mindLevelId,
    int? bodyLevelId,
    int? spiritLevelId,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return UserLevel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mindLevelId: mindLevelId ?? this.mindLevelId,
      bodyLevelId: bodyLevelId ?? this.bodyLevelId,
      spiritLevelId: spiritLevelId ?? this.spiritLevelId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'mindLevelId': mindLevelId,
      'bodyLevelId': bodyLevelId,
      'spiritLevelId': spiritLevelId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory UserLevel.fromMap(Map<String, dynamic> map) {
    return UserLevel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      mindLevelId: map['mindLevelId'] as int,
      bodyLevelId: map['bodyLevelId'] as int,
      spiritLevelId: map['spiritLevelId'] as int,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLevel.fromJson(String source) => UserLevel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserLevel(id: $id, userId: $userId, mindLevelId: $mindLevelId, bodyLevelId: $bodyLevelId, spiritLevelId: $spiritLevelId, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant UserLevel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.mindLevelId == mindLevelId &&
      other.bodyLevelId == bodyLevelId &&
      other.spiritLevelId == spiritLevelId &&
      other.createDate == createDate &&
      other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      mindLevelId.hashCode ^
      bodyLevelId.hashCode ^
      spiritLevelId.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode;
  }
}
