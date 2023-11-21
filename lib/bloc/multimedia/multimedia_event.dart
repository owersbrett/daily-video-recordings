import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MultimediaEvent {}

class MultimediaInitialize extends MultimediaEvent {}

class AddMultimedia extends MultimediaEvent {
  List<XFile> clips;
  BuildContext context;
  AddMultimedia(this.clips, this.context);
}

class FetchMultimedia extends MultimediaEvent {}

class DeleteMultimedia extends MultimediaEvent {
  final String filePath;

  DeleteMultimedia(this.filePath);
}
