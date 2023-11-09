import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class VideoCamera extends StatefulWidget {
  final CameraDescription camera;

  const VideoCamera({required this.camera});

  @override
  _VideoCameraState createState() => _VideoCameraState();
}

class _VideoCameraState extends State<VideoCamera> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((_cameras) {
      controller = CameraController(_cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Video')),
      // The CameraPreview widget displays the live camera feed to the user
      body: CameraPreview(controller),
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            child: Icon(Icons.videocam),
            // Provide an onPressed callback
            onPressed: controller.value.isRecordingVideo ? () {} : (){},
          ),
          FloatingActionButton(
            child: Icon(Icons.videocam),
            // Provide an onPressed callback
            onPressed: controller.value.isRecordingVideo
                ? (){}
                : (){},
          ),
        ],
      ),
    );
  }
}