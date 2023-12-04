import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:habitbit/pages/video/dvr_close_button.dart';
import 'package:habitbit/service/media_service.dart';
import 'package:habitbit/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:video_player/video_player.dart';

import '../../bloc/habits/habits.dart';
import '../../bloc/multimedia/multimedia.dart';

class RecordVideoPage extends StatefulWidget {
  final CameraDescription camera;

  const RecordVideoPage({super.key, required this.camera});

  @override
  _RecordVideoPageState createState() => _RecordVideoPageState();
}

class _RecordVideoPageState extends State<RecordVideoPage> {
  double progress = 0;
  bool _isSaving = false;
  int currentClipIndex = 0;

  bool _isRecording = false;
  bool _isPreviewingVideo = false;
  bool videoPlaying = false;

  late CameraController _cameraController;
  late VideoPlayerController _videoPlayerController;
  List<XFile> clips = [];

  Future updateProgress() async {
    setState(() {
      progress += 1;
    });
    await Future.delayed(const Duration(milliseconds: 25));
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
    _videoPlayerController = VideoPlayerController.asset(
      "",
    );
  }

  void _toggleBetweenRecordingAndPreviewing() async {
    setState(() {
      _videoPlayerController = VideoPlayerController.file(File(clips[currentClipIndex].path));
      _videoPlayerController.initialize();

      _isPreviewingVideo = !_isPreviewingVideo;
    });
  }

  void _initCamera() async {
    final firstCamera = widget.camera;
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.max,
    );
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _toggleRecording() async {
    if (_isRecording) {
      XFile file = await _cameraController.stopVideoRecording();
      setState(() {
        clips.add(file);
      });
    } else {
      await _cameraController.startVideoRecording();
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void updateClipIndex(bool increment) {
    setState(() {
      currentClipIndex = (currentClipIndex + (increment ? 1 : -1)) % clips.length;
      _videoPlayerController.dispose();
      _videoPlayerController = VideoPlayerController.file(File(clips[currentClipIndex].path));
      _videoPlayerController.initialize();
    });
  }

  Widget _videoPlayer() => GestureDetector(
        onHorizontalDragStart: (details) {
          if (details.localPosition.dx > MediaQuery.of(context).size.width / 2) {
            updateClipIndex(true);
          } else {
            updateClipIndex(false);
          }
        },
        onTap: _toggleVideoPlayer,
        child: VideoPlayer(_videoPlayerController),
      );
  Widget _videoRecorder() => CameraPreview(_cameraController);
  void _toggleVideoPlayer() {
    setState(() {
      if (videoPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
      }
      videoPlaying = !videoPlaying;
    });
  }

  Widget _closeButton() => Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DVRCloseButton(
              positioned: false,
              onPressed: () {
                if (_isPreviewingVideo) {
                  setState(() {
                    _isPreviewingVideo = false;
                  });
                } else if (_isRecording) {
                  setState(() {
                    _isRecording = false;
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      );
  Widget _recordingControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: kToolbarHeight * 2,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Visibility(
                visible: clips.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    Logger.root.info("Delete the most recent clip");
                    if (clips.isNotEmpty) {
                      setState(() {
                        clips.removeLast();
                      });
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: clips.isEmpty ? Colors.grey : Colors.red,
                  ),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: _isPreviewingVideo ? _toggleVideoPlayer : _toggleRecording,
                child: Container(
                  height: _isRecording ? 75 : 65,
                  width: _isRecording ? 75 : 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.white,
                      width: _isRecording ? 3 : 5,
                    ),
                  ),
                  child: SizedBox(
                    height: 55,
                    width: 55,
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.circle,
                      color: _isRecording ? Colors.red : Colors.red,
                      size: _isRecording ? 35 : 55,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: clips.isNotEmpty && !_isRecording && !_isPreviewingVideo,
                child: IconButton(
                  onPressed: () {
                    _toggleBetweenRecordingAndPreviewing();
                  },
                  icon: const Icon(Icons.check),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveVideos() {
    setState(() {
      _isSaving = true;
    });
    BlocProvider.of<MultimediaBloc>(context).add(AddMultimedia(clips, context));
  }

  Widget _savingControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        height: kToolbarHeight * 2,
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Visibility(
              visible: !_isRecording,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (clips.isNotEmpty) {
                        clips.removeLast();
                        if (clips.isEmpty) {
                          _isPreviewingVideo = false;
                        } else {
                          _videoPlayerController = VideoPlayerController.asset(clips.last.path);
                        }
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: lightRuby,
                  )),
            )),
            GestureDetector(
              onTap: _isPreviewingVideo ? _toggleVideoPlayer : _toggleRecording,
              child: Container(
                height: _isRecording ? 75 : 65,
                width: _isRecording ? 75 : 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SizedBox(
                  height: 55,
                  width: 55,
                  child: Icon(
                    videoPlaying ? Icons.stop : Icons.play_arrow,
                    color: videoPlaying ? lightRuby : lightEmerald,
                    size: 55,
                  ),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  _saveVideos();
                },
                icon: const Icon(Icons.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controls() {
    Widget controls = Container();
    if (_isPreviewingVideo) controls = _savingControls();
    if (!_isPreviewingVideo) controls = _recordingControls();
    return controls;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Scaffold(
                      // The CameraPreview widget displays the live camera feed to the user
                      body: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: kToolbarHeight,
                                color: Colors.black,
                              ),
                              _isPreviewingVideo ? Expanded(child: _videoPlayer()) : _videoRecorder()
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                color: emerald,
                                minHeight: kToolbarHeight,
                                backgroundColor: emerald.withOpacity(.3),
                              ),
                            ],
                          ),
                          _closeButton(),
                          _controls()
                        ],
                      ),
                    ),
                  ),
                ),
                _isSaving ? const Center(child: LinearProgressIndicator()) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
