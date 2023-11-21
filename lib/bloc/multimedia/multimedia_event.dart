class MultimediaEvent {}

class MultimediaInitialize extends MultimediaEvent {}

class FetchMultimedia extends MultimediaEvent {}

class DeleteMultimedia extends MultimediaEvent {
  final String filePath;

  DeleteMultimedia(this.filePath);
}
