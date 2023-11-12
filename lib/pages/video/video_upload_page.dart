import 'dart:io';

import 'package:camera/camera.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/data/multimedia_file.dart';
import 'package:daily_video_reminders/main.dart';
import 'package:daily_video_reminders/navigation/navigation.dart';
import 'package:daily_video_reminders/pages/video/record_video_page.dart';
import 'package:daily_video_reminders/service/file_directories_service.dart';
import 'package:daily_video_reminders/service/media_service.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  Future<List<MultimediaFile>>? _multimediaFiles;

  VideoPlayerController? _controller;

  XFile? _videoFile;

  Future<void> _pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = video;
    });
  }

  void _uploadVideo() {
    if (_videoFile != null) {
      // Implement your video uploading logic
      print('Uploading ${_videoFile!.path}');
    }
  }

  // Function to enter full-screen mode
  void _goFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => FullScreenVideo(controller: _controller!)),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _multimediaFiles = MediaService.retrieveMultimediaFiles();
  }

  void refreshData() {
    setState(() {
      _multimediaFiles = MediaService.retrieveMultimediaFiles();
    });
  }

  Widget gridItem(MultimediaFile file, int i, bool hasThumbnail) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          if (hasThumbnail) {
            log(file.videoFile!.path);
          } else {
            MediaService.setThumbnail(file.videoFile!)
                .then((value) => refreshData());
          }
        },
        child: Image.file(
          file.photoFile ?? File(""),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      footer: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.black54,
        child: Text(
          "Video ${i + 1}",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FutureBuilder(
              future: _multimediaFiles,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var files = snapshot.data as List<MultimediaFile>;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 9 / 19.5 * 1.5,
                    ),
                    itemCount: files.length,
                    itemBuilder: (ctx, i) {
                      return gridItem(files[i], i, files[i].photoFile != null);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading videos"));
                }
                return Center(
                  child: Text("No videos found"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideo({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
