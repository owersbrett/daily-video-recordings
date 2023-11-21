// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HabitEntryNote {

  static String tableName = "HabitEntryNote";

  static List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "habitEntryId INTEGER",
    "note TEXT",
    "createDate INTEGER",
    "updateDate INTEGER",
    "title TEXT"
  ];

  final int id;
  final int habitEntryId;
  final String note;
  final DateTime createDate;
  final DateTime updateDate;
  final String title;
  HabitEntryNote({
    required this.id,
    required this.habitEntryId,
    required this.note,
    required this.createDate,
    required this.updateDate,
    required this.title,
  });

  HabitEntryNote copyWith({
    int? id,
    int? habitEntryId,
    String? note,
    DateTime? createDate,
    DateTime? updateDate,
    String? title,
  }) {
    return HabitEntryNote(
      id: id ?? this.id,
      habitEntryId: habitEntryId ?? this.habitEntryId,
      note: note ?? this.note,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'habitEntryId': habitEntryId,
      'note': note,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
      'title': title,
    };
  }

  factory HabitEntryNote.fromMap(Map<String, dynamic> map) {
    return HabitEntryNote(
      id: map['id'] as int,
      habitEntryId: map['habitEntryId'] as int,
      note: map['note'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitEntryNote.fromJson(String source) => HabitEntryNote.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HabitEntryNote(id: $id, habitEntryId: $habitEntryId, note: $note, createDate: $createDate, updateDate: $updateDate, title: $title)';
  }

  @override
  bool operator ==(covariant HabitEntryNote other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.habitEntryId == habitEntryId &&
      other.note == note &&
      other.createDate == createDate &&
      other.updateDate == updateDate &&
      other.title == title;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      habitEntryId.hashCode ^
      note.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode ^
      title.hashCode;
  }
}
