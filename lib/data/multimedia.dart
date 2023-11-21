// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Multimedia {
  static const String tableName = "Multimedia";

  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "path TEXT",
    "createdAt INTEGER",
    "updatedAt INTEGER",
    "lastAccessedAt INTEGER",
    "fileNameWithoutExtension TEXT",
    "habitId INTEGER",
    "habitEntryId INTEGER",
    "videoFileId INTEGER",
    "audioFileId INTEGER",
    "metadataFileId INTEGER"
  ];

  int? id;
  String? path;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastAccessedAt;
  String? fileNameWithoutExtension;
  String? habitId;
  String? habitEntryId;
  String? videoFileId;
  String? audioFileId;
  String? metadataFileId;
  Multimedia({
    this.id,
    this.path,
    this.createdAt,
    this.updatedAt,
    this.lastAccessedAt,
    this.fileNameWithoutExtension,
    this.habitId,
    this.habitEntryId,
    this.videoFileId,
    this.audioFileId,
    this.metadataFileId,
  });

  Multimedia copyWith({
    int? id,
    String? path,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastAccessedAt,
    String? fileNameWithoutExtension,
    String? habitId,
    String? habitEntryId,
    String? videoFileId,
    String? audioFileId,
    String? metadataFileId,
  }) {
    return Multimedia(
      id: id ?? this.id,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      fileNameWithoutExtension: fileNameWithoutExtension ?? this.fileNameWithoutExtension,
      habitId: habitId ?? this.habitId,
      habitEntryId: habitEntryId ?? this.habitEntryId,
      videoFileId: videoFileId ?? this.videoFileId,
      audioFileId: audioFileId ?? this.audioFileId,
      metadataFileId: metadataFileId ?? this.metadataFileId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'path': path,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'lastAccessedAt': lastAccessedAt?.millisecondsSinceEpoch,
      'fileNameWithoutExtension': fileNameWithoutExtension,
      'habitId': habitId,
      'habitEntryId': habitEntryId,
      'videoFileId': videoFileId,
      'audioFileId': audioFileId,
      'metadataFileId': metadataFileId,
    };
  }

  factory Multimedia.fromMap(Map<String, dynamic> map) {
    return Multimedia(
      id: map['id'] != null ? map['id'] as int : null,
      path: map['path'] != null ? map['path'] as String : null,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int) : null,
      lastAccessedAt: map['lastAccessedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastAccessedAt'] as int) : null,
      fileNameWithoutExtension: map['fileNameWithoutExtension'] != null ? map['fileNameWithoutExtension'] as String : null,
      habitId: map['habitId'] != null ? map['habitId'] as String : null,
      habitEntryId: map['habitEntryId'] != null ? map['habitEntryId'] as String : null,
      videoFileId: map['videoFileId'] != null ? map['videoFileId'] as String : null,
      audioFileId: map['audioFileId'] != null ? map['audioFileId'] as String : null,
      metadataFileId: map['metadataFileId'] != null ? map['metadataFileId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Multimedia.fromJson(String source) => Multimedia.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Multimedia(id: $id, path: $path, createdAt: $createdAt, updatedAt: $updatedAt, lastAccessedAt: $lastAccessedAt, fileNameWithoutExtension: $fileNameWithoutExtension, habitId: $habitId, habitEntryId: $habitEntryId, videoFileId: $videoFileId, audioFileId: $audioFileId, metadataFileId: $metadataFileId)';
  }

  @override
  bool operator ==(covariant Multimedia other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.path == path &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.lastAccessedAt == lastAccessedAt &&
        other.fileNameWithoutExtension == fileNameWithoutExtension &&
        other.habitId == habitId &&
        other.habitEntryId == habitEntryId &&
        other.videoFileId == videoFileId &&
        other.audioFileId == audioFileId &&
        other.metadataFileId == metadataFileId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        path.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        lastAccessedAt.hashCode ^
        fileNameWithoutExtension.hashCode ^
        habitId.hashCode ^
        habitEntryId.hashCode ^
        videoFileId.hashCode ^
        audioFileId.hashCode ^
        metadataFileId.hashCode;
  }
}
