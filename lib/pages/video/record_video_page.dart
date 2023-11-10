import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RecordVideoPage extends StatefulWidget {
  final CameraDescription camera;

  const RecordVideoPage({required this.camera});

  @override
  _RecordVideoPageState createState() => _RecordVideoPageState();
}

class _RecordVideoPageState extends State<RecordVideoPage> {
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    final firstCamera = widget.camera;
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _toggleRecording() async {
    if (_isRecording) {
      await _cameraController.stopVideoRecording();
    } else {
      await _cameraController.startVideoRecording();
    }
    setState(() {
      _isRecording = !_isRecording;
    });
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
                
                CameraPreview(_cameraController),
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
                            Center(
                              child: GestureDetector(
                                onTap: _toggleRecording,
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
                                      color: _isRecording
                                          ? Colors.red
                                          : Colors.red,
                                      size: _isRecording ? 35 : 55,
                                    ),
                                  ),
                                ),
                              ),
                            )
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
