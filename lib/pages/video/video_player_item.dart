import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dvr_close_button.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({super.key, required this.path});
  final String path;
  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        _controller?.setLooping(true);
        _controller?.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller?.value.isPlaying ?? false) {
      _controller?.pause();
    } else {
      _controller?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            _controller?.setPlaybackSpeed(2);
          },
          onLongPressEnd: (details) {
            _controller?.setPlaybackSpeed(1);
          },
          onTap: _togglePlay,
          child: VideoPlayer(_controller!),
        ),
        DVRCloseButton(onPressed: () => Navigator.of(context).pop())
      ],
    );
  }
}
