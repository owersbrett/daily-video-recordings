import 'dart:io';
import 'dart:typed_data';
import 'package:daily_video_reminders/data/multimedia_file.dart';
import 'package:flutter_ffmpeg/ffmpeg_execution.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:intl/intl.dart'; // Add this line for date formatting
import 'package:camera/camera.dart';
import 'package:daily_video_reminders/main.dart';
import 'package:daily_video_reminders/service/file_directories_service.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  static Future<MultimediaFile> saveVideoClipsToOneFile(List<XFile> videoClips,
      [String videoId = "videoId"]) async {
    log("saving video");
    final directory = await getApplicationDocumentsDirectory();
    // Use DateFormat to format datetime
    String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();
    String path = directory.path + FileDirectoriesService.videosPath;

    path += videoId + "-" + formattedDate;

    String mp4Path = path + ".mp4";
    String txtPath = path + ".txt";
    String jpgPath = path + ".jpg";
    BytesBuilder combinedBytes = BytesBuilder();
    for (XFile file in videoClips) {
      Uint8List bytes = await file.readAsBytes();
      combinedBytes.add(bytes);
    }

    Uint8List fullVideoBytes = combinedBytes.toBytes();
    File mp4 = File(mp4Path);
    await mp4.writeAsBytes(fullVideoBytes);
    File jpg = File(jpgPath);
    await _captureThumbnail(mp4Path, jpgPath);

    log("Successfully saved video to $path");
    MultimediaFile multimediaFile = MultimediaFile(
        videoFile: mp4,
        photoFile: jpg,
        path: path,
        createdAt: formattedDate,
        id: videoId);
    return multimediaFile;
  }

  static Future<void> _captureThumbnail(
      String videoPath, String thumbnailPath) async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    // FFmpeg command to capture the thumbnail
    int rc = await _flutterFFmpeg
        .execute('-i $videoPath -ss 00:00:01.000 -vframes 1 $thumbnailPath');
    if (rc == 0) {
      log("Thumbnail created at $thumbnailPath");
    } else {
      log("Thumbnail creation failed with exit code $rc");
    }
  }

  static Future setThumbnail(File file) async {
    String videoPath = file.path;
    log('file path: $videoPath');

    String thumbnailPath = getFileDirectory(videoPath) +"/" + getFileNameWithoutExtension(videoPath) + ".jpg";
    log('thumbnail path: $thumbnailPath');
    await _captureThumbnail(videoPath, thumbnailPath);
  }

  static String getFileDirectory(String filePath) {
    List<String> subDirs = filePath.split("/");
    subDirs.removeLast();
    return subDirs.join("/");
  }

  static String getFileNameWithoutExtension(String filePath) {
    return filePath.split("/").last.split(".").first;
  }

  static Future<List<File>> retrieveVideoClips() async {
    final directory = await getApplicationDocumentsDirectory();
    final videoDirectory =
        Directory(directory.path + FileDirectoriesService.videosPath);
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

  static Future<List<MultimediaFile>> retrieveMultimediaFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final videoDirectory =
        Directory(directory.path + FileDirectoriesService.videosPath);
    List<File> videoFiles = await videoDirectory
        .list()
        .where((item) => item.path.endsWith('.mp4')) // Filter for video files
        .map((item) => File(item.path))
        .toList();
    List<File> photoFiles = await videoDirectory
        .list()
        .where((item) => item.path.endsWith('.jpg')) // Filter for video files
        .map((item) => File(item.path))
        .toList();

    Map<String, MultimediaFile> multimediaFiles = {};
    for (var i = 0; i < videoFiles.length; i++) {
      String id = videoFiles[i].path.split("/videos/").last.split(".mp4").first;
      multimediaFiles.putIfAbsent(
        id,
        () => MultimediaFile(
          videoFile: videoFiles[i],
          path: videoFiles[i].path,
          createdAt: _getIntFromFilename(videoFiles[i].path).toString(),
          id: id,
        ),
      );
    }
    for (var element in photoFiles) {
      String id = element.path.split("/videos/").last.split(".jpg").first;
      multimediaFiles[id] == null ?  null : multimediaFiles[id] = multimediaFiles[id]!.copyWith(photoFile: element);
    }

    // Sorting based on datetime in filename
    List<MultimediaFile> multimedia = multimediaFiles.values.toList();

    multimedia.sort((b, a) {
      int aDate = _getIntFromFilename(a.videoFile!.path);
      log(aDate.toString());
      var bDate = _getIntFromFilename(b.videoFile!.path);
      log(bDate.toString());
      return aDate.compareTo(bDate);
    });

    return multimedia;
  }

  static void deleteMedia() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory dir =
        Directory(directory.path + FileDirectoriesService.videosPath);
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
