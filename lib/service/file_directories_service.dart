import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';


class FileDirectoriesService {
  static String videosPath = "/videos/";
  static String photosPath = "/photos/";
  static String privatePath = "/private/";
  static String audioPath = "/audio/";
  String applicationDocumentsDirectory = "";

  Future init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    applicationDocumentsDirectory = directory.path;
    createPaths();
  }

  Future createPaths() async {
    Directory videoDir = Directory(applicationDocumentsDirectory + videosPath);
    Directory photosDir = Directory(applicationDocumentsDirectory + photosPath);
    Directory privateDir = Directory(applicationDocumentsDirectory + privatePath);
    Directory audioDirectory = Directory(applicationDocumentsDirectory + audioPath);

    if (!videoDir.existsSync()) videoDir.createSync();
    if (!photosDir.existsSync()) photosDir.createSync();
    if (!privateDir.existsSync()) privateDir.createSync();
    if (!audioDirectory.existsSync()) audioDirectory.createSync();

  }

  
}
