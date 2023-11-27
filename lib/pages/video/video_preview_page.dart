import 'dart:io';

import 'package:camera/camera.dart';
import 'package:mementohr/data/multimedia_file.dart';
import 'package:mementohr/main.dart';
import 'package:mementohr/navigation/navigation.dart';
import 'package:mementohr/pages/video/loading_page.dart';
import 'package:mementohr/pages/video/record_video_page.dart';
import 'package:mementohr/pages/video/video_swipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../bloc/multimedia/multimedia.dart';

class VideoPreviewPage extends StatefulWidget {
  const VideoPreviewPage({super.key});

  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  VideoPlayerController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MultimediaBloc>(context).add(FetchMultimedia());
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
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "No video entries.\nTap to create one!",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
