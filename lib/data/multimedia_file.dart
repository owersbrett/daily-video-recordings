import 'dart:io';

class MultimediaFile {
  final String? path;
  final String? createdAt;
  final String? fileNameWithoutExtension;
  final String? id;
  final File? videoFile;
  final File? audioFile;
  final File? photoFile;
  final File? metadataFile;

  MultimediaFile({
    this.id,
    this.path,
    this.createdAt,
    this.fileNameWithoutExtension,
    this.videoFile,
    this.audioFile,
    this.photoFile,
    this.metadataFile,
  });

  MultimediaFile copyWith({
    File? photoFile,
    File? videoFile,
    File? audioFile,
    File? metadataFile,
    String? path,
    String? createdAt,
    String? fileNameWithoutExtension,
    String? id,
  }) {
    return MultimediaFile(
      photoFile: photoFile ?? this.photoFile,
      videoFile: videoFile ?? this.videoFile,
      audioFile: audioFile ?? this.audioFile,
      metadataFile: metadataFile ?? this.metadataFile,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      fileNameWithoutExtension:
          fileNameWithoutExtension ?? this.fileNameWithoutExtension,
      id: id ?? this.id,
    );
  }
}
