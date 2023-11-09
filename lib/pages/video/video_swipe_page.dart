

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSwipePage extends StatefulWidget {
  @override
  _VideoSwipePageState createState() => _VideoSwipePageState();
}

class _VideoSwipePageState extends State<VideoSwipePage> {
  late final List<VideoPlayerController> _controllers;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize a list of VideoPlayerControllers with your video sources
    _controllers = [
      VideoPlayerController.networkUrl(Uri(path: "https://i.vimeocdn.com/video/1130115759-34074c1d4b9e421312e88c1482f2a80387a892507f4187614fe510ca2b9272da-d?mw=400&mh=757")),
      VideoPlayerController.networkUrl(Uri(path: "https://i.vimeocdn.com/video/1130115759-34074c1d4b9e421312e88c1482f2a80387a892507f4187614fe510ca2b9272da-d?mw=400&mh=757")),
      VideoPlayerController.networkUrl(Uri(path: "https://i.vimeocdn.com/video/1130115759-34074c1d4b9e421312e88c1482f2a80387a892507f4187614fe510ca2b9272da-d?mw=400&mh=757")),
      // Add more video URLs or asset paths
    ];

    for (var controller in _controllers) {
      controller
        ..initialize().then((_) {
          setState(() {}); // When the video is initialized, update the UI
        })
        ..setLooping(true) // If you want the video to loop
        ..play(); // Start playing the video as soon as it's loaded
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          final controller = _controllers[index];
          return controller.value.isInitialized
              ? VideoPlayer(controller)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
