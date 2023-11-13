import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPreview extends StatefulWidget {
  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;
  final StreamController<String> _videoStreamController = StreamController.broadcast();
  late StreamSubscription<String> _videoSubscription;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('') // Start with an empty URL or some placeholder
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);

    // Listen to the stream of video paths
    _videoSubscription = _videoStreamController.stream.listen((newVideoPath) {
      _controller.dispose();
      _controller = VideoPlayerController.file(File(newVideoPath))
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    });
  }

  void addVideo(String videoPath) {
    _videoStreamController.add(videoPath);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your logic to pick or receive a new video path
            String newVideoPath = 'path_to_new_video.mp4';
            addVideo(newVideoPath);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _videoSubscription.cancel();
    _videoStreamController.close();
  }
}
