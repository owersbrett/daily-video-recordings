import 'dart:io';
import 'package:daily_video_reminders/data/multimedia_file.dart';
import 'package:daily_video_reminders/main.dart';
import 'package:daily_video_reminders/pages/video/video_player_item.dart';
import 'package:daily_video_reminders/service/media_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VideoSwipePage extends StatefulWidget {
  const VideoSwipePage({Key? key, this.multimediaFile}) : super(key: key);
  final MultimediaFile? multimediaFile;
  @override
  _VideoSwipePageState createState() => _VideoSwipePageState();
}

class _VideoSwipePageState extends State<VideoSwipePage> {
  PageController pageController = PageController(initialPage: 0, viewportFraction: 1);

  List<File> videos = [];
  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
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

  @override
  void initState() {
    super.initState();
    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    var videoFiles = await MediaService.retrieveVideoClips();
   
    setState(() {
      isLoading = false;
      videos = videoFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (videos.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text("No videos found"),
        ),
      );
    }
    return Scaffold(
        body: PageView.builder(
      itemCount: videos.length,
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final data = videos[index];
        log(index.toString());
        return Stack(
          children: [
            VideoPlayerItem(path: data.path),
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "data.username",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "data.caption",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.music_note,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "data.songName",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        margin: EdgeInsets.only(top: size.height / 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildProfile("data.profilePhoto"),
                            Column(
                              children: [
                                InkWell(
                                  // onTap: () => videoController.likeVideo(data.id),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 40,
                                    // color: data.likes.contains(authController.user.uid) ? Colors.red : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  "data.likes.length.toString()",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  // onTap: () => Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => CommentScreen(
                                  //       id: data.id,
                                  //     ),
                                  //   ),
                                  // ),
                                  child: const Icon(
                                    Icons.comment,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  "data.commentCount.toString()",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.reply,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  "data.shareCount.toString()",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            // CircleAnimation(
                            //   child: buildMusicAlbum(data.profilePhoto),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ));
  }
}
