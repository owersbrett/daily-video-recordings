import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

class RecordVideoPage extends StatefulWidget {
  final CameraDescription camera;

  const RecordVideoPage({required this.camera});

  @override
  _RecordVideoPageState createState() => _RecordVideoPageState();
}

class _RecordVideoPageState extends State<RecordVideoPage> {
  bool _isRecording = false;
  bool _isPreviewingVideo = false;
  bool videoPlaying = false;
  double _aspectRatio = 9 / 19.5;

  late CameraController _cameraController;
  late VideoPlayerController _videoPlayerController;
  List<XFile> clips = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
    _videoPlayerController = VideoPlayerController.asset(
      "",
    );
  }

  void _togglePreview() {
    if (!_isRecording) {
      setState(() {
        _videoPlayerController = VideoPlayerController.file(File(clips[0].path));

        Logger.root.info(_aspectRatio);
        _videoPlayerController.initialize();

        _isPreviewingVideo = !_isPreviewingVideo;
      });
    }
  }

  void _initCamera() async {
    final firstCamera = widget.camera;
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.max,
    );
    await _cameraController.initialize();
    Size aspectSize = _cameraController.value.previewSize ?? Size(1,1);
    setState(() {
      _aspectRatio = aspectSize.height / aspectSize.width;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
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

  Widget _videoPlayerAndRecorder() => _isPreviewingVideo ? _videoPlayer() : _videoRecorder();
  Widget _videoPlayer() => AspectRatio(aspectRatio: _aspectRatio, child: VideoPlayer(_videoPlayerController));
  Widget _videoRecorder() => CameraPreview(_cameraController);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        // The CameraPreview widget displays the live camera feed to the user
        body: Stack(
          children: [
            Column(
              children: [
                _videoPlayerAndRecorder(),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: IconButton(onPressed: () {}, icon: Icon(Icons.delete))),
                            Center(
                              child: GestureDetector(
                                onTap: _isPreviewingVideo
                                    ? () {
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
                                    : _toggleRecording,
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
                                  child: Container(
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
                                child: IconButton(
                                    onPressed: () {
                                      _togglePreview();
                                    },
                                    icon: Icon(Icons.check))),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              right: 8,
              top: kToolbarHeight,
              child: Container(
                height: 60,
                width: 60,
                child: IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  iconSize: 35,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
