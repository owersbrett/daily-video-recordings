import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:daily_video_reminders/data/multimedia_file.dart';
import 'package:daily_video_reminders/main.dart';
import 'package:daily_video_reminders/service/media_service.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:daily_video_reminders/service/file_directories_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../navigation/navigation.dart';

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
    _aspectRatio =  MediaQuery.of(context).size.aspectRatio;
    _initCamera();
    _videoPlayerController = VideoPlayerController.asset(
      "",
    );
  }

  void _toggleBetweenRecordingAndPreviewing() {
    setState(() {
      String clipPath = clips[0].path;
      _videoPlayerController = VideoPlayerController.file(File(clipPath));
      Logger.root.info(clipPath);
      Logger.root.info(_aspectRatio);
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
    Size aspectSize = _cameraController.value.previewSize ?? Size(1, 1);
    setState(() {
      _aspectRatio = aspectSize.height / aspectSize.width;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoPlayerController.dispose();
    ;
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

  Widget _videoPlayerAndRecorder() =>
      _isPreviewingVideo ? _videoPlayer() : _videoRecorder();
  Widget _videoPlayer() => GestureDetector(
        onTap: _toggleVideoPlayer,
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: VideoPlayer(_videoPlayerController),
        ),
      );
  Widget _videoRecorder() => CameraPreview(_cameraController);
  void _toggleVideoPlayer() {
    log("Toggling video player");
    log("Video playing: ${clips.last.path}");
    log(videoPlaying.toString());
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

  Widget _closeButton() => Positioned(
        right: 8,
        top: kToolbarHeight,
        child: Container(
          height: 60,
          width: 60,
          child: IconButton(
            onPressed: () async {
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
            icon: Icon(Icons.close),
            color: Colors.white,
            iconSize: 35,
          ),
        ),
      );
  Widget _recordingControls() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        Logger.root.info("Delete the most recent clip");
                        if (clips.length > 0) {
                          setState(() {
                            clips.removeLast();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: clips.length == 0 ? Colors.grey : Colors.red,
                      ))),
              Center(
                child: GestureDetector(
                  onTap: _isPreviewingVideo
                      ? _toggleVideoPlayer
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
                child: Visibility(
                  visible:
                      clips.length > 0 && !_isRecording && !_isPreviewingVideo,
                  child: IconButton(
                    onPressed: () {
                      _toggleBetweenRecordingAndPreviewing();
                    },
                    icon: Icon(Icons.check),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Future<File> _saveVideos() async {
    MultimediaFile multimediaFile =
        await MediaService.saveVideoClipsToOneFile(clips, Uuid().v4());
    if (multimediaFile.videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Video file is null"),
        ),
      );
      throw Exception("Video file is null");
    } else {
      File file = multimediaFile.videoFile!;
      Navigator.of(context).popUntil((route) => route.isFirst);
      log(file.path);
      return file;
    }
  }

  Widget _savingControls() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Row(
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
                            _videoPlayerController =
                                VideoPlayerController.asset(clips.last.path);
                          }
                        }
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: rubyLight,
                    )),
              )),
              Center(
                child: GestureDetector(
                  onTap: _isPreviewingVideo
                      ? _toggleVideoPlayer
                      : _toggleRecording,
                  child: Container(
                    height: _isRecording ? 75 : 65,
                    width: _isRecording ? 75 : 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      height: 55,
                      width: 55,
                      child: Icon(
                        videoPlaying ? Icons.stop : Icons.play_arrow,
                        color: videoPlaying ? rubyLight : emeraldLight,
                        size: 55,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    _saveVideos();
                  },
                  icon: Icon(Icons.save),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _controls() {
    return !_isPreviewingVideo ? _recordingControls() : _savingControls();
  }

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
                  child: _controls(),
                ),
              ],
            ),
            _closeButton(),
          ],
        ),
      ),
    );
  }
}
