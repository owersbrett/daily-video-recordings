// import 'package:camera/camera.dart';
// import 'package:video_player/video_player.dart';

// class PlaylistManager {
//   final List<XFile> playlist;
//   int currentIndex = 0;

//   late VideoPlayerController previousVideoController;
//   late VideoPlayerController currentVideoController;
//   late VideoPlayerController nextVideoController;

//   PlaylistManager(this.playlist, this.previousVideoController, this.currentVideoController, this.nextVideoController);) {
//     previousVideoController.addListener(_onPlayerStateChanged);
//     currentVideoController.addListener(_onPlayerStateChanged); 
//     nextVideoController.addListener(_onPlayerStateChanged);
//   }

//   void play() {
//     if (playlist.isNotEmpty) {
//       _playFile(playlist[currentIndex]);
//     }
//   }

//   void _playFile(XFile file) {
//     // Initialize and play the file using playerController
//     // playerController.initialize(file.path).then((_) {
//     //   playerController.play();
//     // });
//   }

//   void _onPlayerStateChanged() {
//     if (playlist.isNotEmpty && playerController.value.position >= playerController.value.duration) {
//       _playNext();
//     }
//   }

//   void _playNext() {
//     if (currentIndex < playlist.length - 1) {
//       currentIndex++;
//       _playFile(playlist[currentIndex]);
//     }
//   }
// }
