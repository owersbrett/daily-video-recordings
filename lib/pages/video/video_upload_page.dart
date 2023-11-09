import 'package:camera/camera.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/navigation/navigation.dart';
import 'package:daily_video_reminders/pages/video/video_camera.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  VideoPlayerController? _controller;

  XFile? _videoFile;

  Future<void> _pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = video;
    });
  }

  void _uploadVideo() {
    if (_videoFile != null) {
      // Implement your video uploading logic
      print('Uploading ${_videoFile!.path}');
    }
  }

  // Function to enter full-screen mode
  void _goFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => FullScreenVideo(controller: _controller!)),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the controller with a video asset or network URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: rubyLight.withOpacity(.5),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              CupertinoIcons.circle_fill,
              size: 36,
              color: rubyLight,
            ),
          ),
        ),
        onPressed: () {
          Navigation.createRoute(
              VideoCamera(
                camera: CameraDescription(
                    name: "Video Note",
                    lensDirection: CameraLensDirection.front,
                    sensorOrientation: 0),
              ),
              context);
        },
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _pickVideo,
                  child: Text('Pick Video'),
                ),
                SizedBox(height: 20),
                _videoFile != null
                    ? Text('Selected video: ${_videoFile!.name}')
                    : Text('No video selected.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _videoFile != null ? _uploadVideo : null,
                  child: Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    primary: _videoFile != null ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideo({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
