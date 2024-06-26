import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:habit_planet/bloc/multimedia/multimedia.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:habit_planet/pages/video/delete_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../bloc/habits/habits.dart';
import '../../theme/theme.dart';
import 'dvr_close_button.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({super.key, required this.path, required this.videoController});
  final VideoPlayerController videoController;
  final String path;
  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  int progress = 0;
  bool get isSaving => progress != 100 && progress != 0;

  Future downloadVideo() async {
    setState(() {
      progress = 1;
    });

    await ImageGallerySaver.saveFile(widget.path);

    while (progress < 100) {
      await updateProgress();
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.black,
      content: Text("Video Saved"),
      duration: Duration(seconds: 1),
    ));
  }

  Future updateProgress() async {
    setState(() {
      progress += 1;
    });
    await Future.delayed(const Duration(milliseconds: 25));
  }

  VideoPlayerController get _controller => widget.videoController;
  Timer _timer = Timer.periodic(const Duration(days: 1), (timer) {});
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
        Expanded(child: Container()),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: infoColumn()),
          ],
        ),
      ],
    );
  }

  Widget deleteIcon() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => DeleteDialog(
            title: "Delete Video?",
            description: "Are you sure you want to delete this video?",
            onDelete: () {
              BlocProvider.of<MultimediaBloc>(context).add(DeleteMultimedia(widget.path));
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            onCancel: () {
              Navigator.of(ctx).pop();
            },
          ),
        );
      },
      child: const Icon(
        Icons.delete,
        size: 32,
        color: Colors.red,
      ),
    );
  }

  Widget _videoSlider() {
    return Expanded(
      child: Slider(
        activeColor: emerald,
        inactiveColor: Colors.white.withOpacity(.5),
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
          Row(
            children: [Text(formattedTimer, style: const TextStyle(color: Colors.white)), _videoSlider()],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onLongPress: () {
                  _controller.setPlaybackSpeed(2);
                },
                onLongPressEnd: (details) {
                  _controller.setPlaybackSpeed(1);
                },
                onTap: _togglePlay,
                child: VideoPlayer(_controller),
              ),
              overlay(),
              Positioned(
                  left: 8,
                  top: kToolbarHeight / 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download),
                        iconSize: 32,
                        onPressed: () async {
                          downloadVideo();
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      deleteIcon()
                    ],
                  )),
              DVRCloseButton(onPressed: () => Navigator.of(context).pop())
            ],
          ),
        ),
        isSaving ? const Center(child: LinearProgressIndicator()) : Container(),
      ],
    );
  }
}
