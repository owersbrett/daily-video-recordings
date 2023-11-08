import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Center(
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
              child: Text('Upload Video'),
              style: ElevatedButton.styleFrom(
                primary: _videoFile != null ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
