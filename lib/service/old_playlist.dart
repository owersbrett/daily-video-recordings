import 'dart:io';
import 'package:video_player/video_player.dart';

import '../main.dart';

class PlaylistService {
  List<File> files = [];
  int currentFileIndex = 0;
  VideoPlayerController? controllerZero;
  VideoPlayerController? controllerOne;
  VideoPlayerController? controllerTwo;

  int get currentControllerIndex => currentFileIndex % 3;
  VideoPlayerController? get currentController => currentControllerIndex == 0
      ? controllerOne
      : currentControllerIndex == 1
          ? controllerTwo
          : controllerZero;
  VideoPlayerController? get aboveController => currentControllerIndex == 0
      ? controllerZero
      : currentControllerIndex == 1
          ? controllerOne
          : controllerTwo;
  VideoPlayerController? get belowController => currentControllerIndex == 0
      ? controllerTwo
      : currentControllerIndex == 1
          ? controllerZero
          : controllerOne;

  Future<PlaylistService> init(List<File> videoFiles) async {
    log("Initialized playlist service with ${files.length} files");
    assert(videoFiles.isNotEmpty);
    files = videoFiles;

    if (videoFiles.length == 1) {
      controllerZero = VideoPlayerController.file(files[0])..initialize();
      controllerOne = VideoPlayerController.file(files[0])..initialize();
      controllerTwo = VideoPlayerController.file(files[0])..initialize();
    } else if (videoFiles.length == 2) {
      controllerZero = VideoPlayerController.file(files[0])..initialize();
      controllerOne = VideoPlayerController.file(files[1])..initialize();
      controllerTwo = VideoPlayerController.file(files[0])..initialize();
    } else if (videoFiles.length >= 3) {
      controllerZero = VideoPlayerController.file(files[0])..initialize();
      controllerOne = VideoPlayerController.file(files[1])..initialize();
      controllerTwo = VideoPlayerController.file(files[2])..initialize();
    }
    log("Initialized playlist service with ${files.length} files");

    return this;                         
  }

  void switchToNextVideo() {                                
    currentFileIndex = (currentFileIndex + 1) % files.length;
    log("Switching to next video: $currentFileIndex");

    if (currentFileIndex % 3 == 0) {                                                                           
      controllerZero?.dispose();                                                            
      controllerZero = VideoPlayerController.file(files[currentFileIndex])..initialize();
    } else if (currentFileIndex % 3 == 1) {
      controllerOne?.dispose();                                                            
      controllerOne = VideoPlayerController.file(files[currentFileIndex])..initialize();
    } else if (currentFileIndex % 3 == 2) {
      controllerTwo?.dispose();
      controllerTwo = VideoPlayerController.file(files[currentFileIndex])..initialize();
    } 

    currentController?.play();
  }

  void switchToPreviousVideo() {
    currentFileIndex = currentFileIndex == 0 ? files.length - 1 : currentFileIndex - 1;
    log("Switching to previous video with index $currentFileIndex");
    if (currentFileIndex % 3 == 0) {
      controllerZero?.dispose();
      controllerZero = VideoPlayerController.file(files[currentFileIndex])..initialize();
      
    } else if (currentFileIndex % 3 == 1) {
      controllerOne?.dispose();
      controllerOne = VideoPlayerController.file(files[currentFileIndex])..initialize();
    } else if (currentFileIndex % 3 == 2) {
      controllerTwo?.dispose();
      controllerTwo = VideoPlayerController.file(files[currentFileIndex])..initialize();
    }

    currentController?.play();
  }

  void togglePlay() => currentController!.value.isPlaying ? pause() : play();

  void play() {
    currentController?.play();
  }

  void pause() {
    currentController?.pause();
  }

  void dispose() {
    currentController?.dispose();
    aboveController?.dispose();
    belowController?.dispose();
  }
}
