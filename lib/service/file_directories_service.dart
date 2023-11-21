import 'dart:io';

import 'package:path_provider/path_provider.dart';


class FileDirectoriesService {
  static String videosPath = "/videos/";
  static String photosPath = "/photos/";
  static String privatePath = "/private/";
  static String audioPath = "/audio/";
  static String metadataPath = "/metadata/";
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
    Directory metadataDirectory = Directory(applicationDocumentsDirectory + metadataPath);

    if (!videoDir.existsSync()) videoDir.createSync();
    if (!photosDir.existsSync()) photosDir.createSync();
    if (!privateDir.existsSync()) privateDir.createSync();
    if (!audioDirectory.existsSync()) audioDirectory.createSync();
    if (!metadataDirectory.existsSync()) metadataDirectory.createSync();

  }


  
}
