import 'dart:io';
import 'package:habit_planet/data/multimedia_file.dart';
import 'package:habit_planet/pages/video/video_player_item.dart';
import 'package:habit_planet/service/media_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSwipePage extends StatefulWidget {
  const VideoSwipePage({Key? key, this.multimediaFile, this.page}) : super(key: key);
  final int? page;
  final MultimediaFile? multimediaFile;
  @override
  _VideoSwipePageState createState() => _VideoSwipePageState();
}

class _VideoSwipePageState extends State<VideoSwipePage> {
  late PageController _pageController;

  Future<List<File>> videosFuture = MediaService.retrieveVideoClips();
  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            // child: ClipRRect(
            //   borderRadius: BorderRadius.circular(25),
            //   child: Image(
            //     image: NetworkImage(profilePhoto),
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ),
        )
      ]),
    );
  }

  bool isLoading = true;
  bool switching = false;
  bool scrolledToPage = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.page ?? 0);
  }

  // Widget actionColumn(Size size) {
  //   return Container(
  //     width: 100,
  //     margin: EdgeInsets.only(top: size.height / 5),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         buildProfile("data.profilePhoto"),
  //         Column(
  //           children: [
  //             InkWell(
  //               // onTap: () => videoController.likeVideo(data.id),
  //               child: Icon(
  //                 Icons.favorite,
  //                 size: 40,
  //                 // color: data.likes.contains(authController.user.uid) ? Colors.red : Colors.white,
  //               ),
  //             ),
  //             const SizedBox(height: 7),
  //             Text(
  //               "data.likes.length.toString()",
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.white,
  //               ),
  //             )
  //           ],
  //         ),
  //         Column(
  //           children: [
  //             InkWell(
  //               // onTap: () => Navigator.of(context).push(
  //               //   MaterialPageRoute(
  //               //     builder: (context) => CommentScreen(
  //               //       id: data.id,
  //               //     ),
  //               //   ),
  //               // ),
  //               child: const Icon(
  //                 Icons.comment,
  //                 size: 40,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             const SizedBox(height: 7),
  //             Text(
  //               "data.commentCount.toString()",
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.white,
  //               ),
  //             )
  //           ],
  //         ),
  //         Column(
  //           children: [
  //             InkWell(
  //               onTap: () {},
  //               child: const Icon(
  //                 Icons.reply,
  //                 size: 40,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             const SizedBox(height: 7),
  //             Text(
  //               "data.shareCount.toString()",
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.white,
  //               ),
  //             )
  //           ],
  //         ),
  //         // CircleAnimation(
  //         //   child: buildMusicAlbum(data.profilePhoto),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: videosFuture,
          builder: (ctx, data) {
            if (data.hasData) {
              final videos = data.data as List<File>;
              return PageView.builder(
                itemCount: videos.length,
                controller: _pageController,
                scrollDirection: Axis.vertical,
                restorationId: "video_swipe_page",
                itemBuilder: (context, index) {
                  final data = videos[index];
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Container(color: Colors.black),
                          ),
                          AspectRatio(
                            aspectRatio: 9 / 16,
                            child: VideoPlayerItem(
                              path: data.path,
                              videoController: VideoPlayerController.file(File(data.path)),
                            ),
                          ),
                          Expanded(
                            child: Container(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
