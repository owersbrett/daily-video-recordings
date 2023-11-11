import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart'; // Add this line for date formatting
import 'package:camera/camera.dart';
import 'package:daily_video_reminders/main.dart';
import 'package:daily_video_reminders/service/file_directories_service.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  static Future<File> saveVideoClipsToOneFile(List<XFile> videoClips, [String videoId = "videoId"]) async {
    log("saving video");
    final directory = await getApplicationDocumentsDirectory();
    // Use DateFormat to format datetime
    String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();
    String path = directory.path + FileDirectoriesService.videosPath + videoId + "-" + formattedDate + ".mp4";
    BytesBuilder combinedBytes = BytesBuilder();
    for (XFile file in videoClips) {
      Uint8List bytes = await file.readAsBytes();
      combinedBytes.add(bytes);
    }
    Uint8List fullVideoBytes = combinedBytes.toBytes();
    File outputFile = File(path);
    await outputFile.writeAsBytes(fullVideoBytes);
    log("Successfully saved video to $path");
    return outputFile;
  }

  static Future<List<File>> retrieveVideoClips() async {
    final directory = await getApplicationDocumentsDirectory();
    final videoDirectory = Directory(directory.path + FileDirectoriesService.videosPath);
    List<File> videoFiles = await videoDirectory
        .list()
        .where((item) => item.path.endsWith('.mp4')) // Filter for video files
        .map((item) => File(item.path))
        .toList();

    // Sorting based on datetime in filename
    videoFiles.sort((b, a) {
      int aDate = _getIntFromFilename(a.path);
      log(aDate.toString());
      var bDate = _getIntFromFilename(b.path);
      log(bDate.toString());
      return aDate.compareTo(bDate);
    });

    return videoFiles;
  }

  static void deleteMedia() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory dir = Directory(directory.path + FileDirectoriesService.videosPath);
    dir.deleteSync(recursive: true);
  }

  // Helper function to extract datetime from the file path
  static int _getIntFromFilename(String path) {

    try {
      var dateString = path.split('-').last.split('.').first;
      return int.tryParse(dateString) ?? 0;
    } catch (e) {
      log("Error parsing date from filename: $e");
      return 0; // Default to current time in case of parsing error
    }
  }
}
