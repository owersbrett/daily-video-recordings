import 'dart:async';
import 'dart:io';
import 'package:daily_video_reminders/main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dvr_close_button.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({super.key, required this.path, required this.videoController});
  final VideoPlayerController videoController;
  final String path;
  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController get _controller => widget.videoController;
  Timer _timer = Timer.periodic(Duration(days: 1), (timer) {});
  int secondsRemaining = 0;
  int secondsElapsed = 0;
  @override
  void initState() {
    super.initState();
    _controller
      ..initialize()
      ..setLooping(true)
      ..play();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_controller.value.isPlaying) {
        setState(() {
          secondsRemaining = _controller.value.duration.inSeconds - _controller.value.position.inSeconds;
          secondsElapsed = _controller.value.position.inSeconds;
        });
      }
    });
  }

  String get formattedTimer {
    if (secondsRemaining == 0) {
      return "";
    }
    if (secondsRemaining < 60) {
      return "${secondsRemaining}s";
    } else if (secondsRemaining < 3600) {
      return "${(secondsRemaining / 60).floor()}m ${(secondsRemaining % 60).floor()}s";
    } else {
      return "${(secondsRemaining / 3600).floor()}h ${((secondsRemaining % 3600) / 60).floor()}m";
    }
  }


  Widget overlay() {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              infoColumn(),
              Expanded(child: actionColumn())


            ],
          ),
        ),
      ],
    );
  }
  Widget actionColumn() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  showDialog(context: context, builder: 
                  (ctx) => AlertDialog(
                    title: const Text("Delete Video?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    content: const Text("Are you sure you want to delete this video?"),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.of(ctx).pop();
                      }, child: const Text("Cancel", style: TextStyle(color: Colors.black),)),
                      TextButton(onPressed: () {
                        File(widget.path).delete();
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      }, child: const Text("Delete", style: TextStyle(color: Colors.red), ))
                    ],
                  )
                  );
                },
                child: const Icon(
                  Icons.delete,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          // CircleAnimation(
          //   child: buildMusicAlbum(data.profilePhoto),
          // ),
        ],
      ),
    );
  }
  Widget _videoSlider(){
    return Expanded(
      child: Slider(
        value: secondsElapsed.toDouble(),
        min: 0,
        max: _controller.value.duration.inSeconds.toDouble(),
        onChanged: (value) {
          setState(() {
            _controller.seekTo(Duration(seconds: value.toInt()));
          });
        },
      ),
    );
  }

  Widget infoColumn() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width / 3 * 2,
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("$formattedTimer", style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              const Icon(
                Icons.music_note,
                size: 15,
                color: Colors.white,
              ),
              _videoSlider()
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer.cancel();
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
        overlay(),
        DVRCloseButton(onPressed: () => Navigator.of(context).pop())
      ],
    );
  }
}
