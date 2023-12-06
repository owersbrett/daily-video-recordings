// import 'package:camera/camera.dart';
// import 'package:HabitPlanet/bloc/playlist/playlist_event.dart';
// import 'package:HabitPlanet/bloc/playlist/playlist_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path/path.dart';

// class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
//   List<XFile> playlist;
//   late VideoPlayerController currentController;
//   late VideoPlayerController nextController;
//   late VideoPlayerController prevController;
//   int currentIndex = 0;

//   PlaylistBloc(this.playlist) : super(InitialPlaylistState()) {
//     // Initialize controllers and other setup
//   }

// // Handling each event
//   @override
//   Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
//     if (event is UpSwipeEvent) {
//       // Handle up swipe, like increasing volume or changing brightness
//     } else if (event is DownSwipeEvent) {
//       // Handle down swipe
//     }
//     // ... other event handlers
//   }

//   // Additional methods for controller management and state updates
// }
