import 'dart:io';

import 'package:camera/camera.dart';
import 'package:mementoh/data/db.dart';
import 'package:mementoh/data/multimedia_file.dart';
import 'package:mementoh/main.dart';
import 'package:mementoh/navigation/navigation.dart';
import 'package:mementoh/pages/video/loading_page.dart';
import 'package:mementoh/pages/video/record_video_page.dart';
import 'package:mementoh/pages/video/video_swipe_page.dart';
import 'package:mementoh/service/file_directories_service.dart';
import 'package:mementoh/service/media_service.dart';
import 'package:mementoh/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../bloc/multimedia/multimedia.dart';

class VideoPreviewPage extends StatefulWidget {
  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  Future<List<MultimediaFile>>? _multimediaFiles;

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
      MaterialPageRoute(builder: (context) => FullScreenVideo(controller: _controller!)),
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
    _multimediaFiles = MediaService.retrieveMultimediaFiles();
  }

  void refreshData() {
    setState(() {
      _multimediaFiles = MediaService.retrieveMultimediaFiles();
    });
  }

  Widget gridItem(MultimediaFile file, int i, bool hasThumbnail) {
    return GridTile(
      child: Image.file(
        file.photoFile ?? File(""),
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, state) {
        if (state is! MultimediaLoaded) {
          return const LoadingPage();
        }
        var files = state.multimediaList;
        if (files.isEmpty) {
          return Center(
            child: InkWell(
              onTap: () {
                Navigation.createRoute(RecordVideoPage(camera: cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front)),
                    context, AnimationEnum.pageAscend);
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "No video entries.\nTap to create one!",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 9 / 19.5 * 1.5,
                  ),
                  itemCount: files.length,
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoSwipePage(multimediaFile: files[i], page: i)),
                        );
                      },
                      child: gridItem(files[i], i, files[i].photoFile != null),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
