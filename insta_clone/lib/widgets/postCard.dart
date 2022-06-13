import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/likeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:insta_clone/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  void getVideoFromCache() async {
    final file =
        await DefaultCacheManager().getFileFromCache(widget.snap['postUrl']);
    if (file == null || file.file == null) {
      print("not in cache");
      DefaultCacheManager().downloadFile(widget.snap['postUrl']);
      setState(() {
        _videoController =
            VideoPlayerController.network(widget.snap['postUrl']);
      });
    } else {
      print("already in cache");
      setState(() {
        _videoController = VideoPlayerController.file(file.file);
      });
    }
    print(_videoController.dataSourceType);
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    // _videoController = VideoPlayerController.network(
    //   widget.snap['postUrl'],
    //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    // );
    if (widget.snap['isVideo']) {
      getVideoFromCache();
    }
    // _videoController.addListener(() {
    //   setState(() {});
    // });
    // _videoController.setLooping(true);
    // _videoController.initialize();
    // _videoController.play();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBgColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child:
                        CachedNetworkImage(imageUrl: widget.snap['profImage'])),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    widget.snap['username'],
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethod().likedPost(
                widget.snap['postId'], user.uid, widget.snap['likes'], true);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
                // height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: widget.snap['isVideo']
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: Chewie(controller: _chewieController))
                    : CachedNetworkImage(
                        imageUrl: widget.snap['postUrl'],
                      )),
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isLikeAnimating ? 1 : 0,
              child: LikeAnimation(
                child: Icon(
                  Icons.favorite_rounded,
                  color: Color(0xffffffff),
                  size: 100,
                ),
                isAnimating: isLikeAnimating,
                duration: Duration(milliseconds: 400),
                smallLike: false,
                onEnd: () {
                  setState(() {
                    isLikeAnimating = false;
                  });
                },
              ),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            children: [
              LikeAnimation(
                onEnd: () {},
                duration: Duration(milliseconds: 400),
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                  onPressed: () async {
                    await FirestoreMethod().likedPost(widget.snap['postId'],
                        user.uid, widget.snap['likes'], false);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.mode_comment_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.ios_share_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border_outlined),
                onPressed: () {},
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 15,
                                ),
                                Text(
                                  widget.snap['likes'].length.toString() +
                                      " likes",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.mode_comment,
                                  size: 15,
                                ),
                                Text(
                                  widget.snap['comments'].length.toString() +
                                      " comments",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ]),
                    )),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, right: 10),
            child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: widget.snap['username'] + " ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.snap['caption'])
                ])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Text(
            DateFormat.yMMMd().format(widget.snap['dateOfPublish'].toDate()),
            style: TextStyle(fontWeight: FontWeight.w400, color: mobileAColor),
          ),
        )
      ]),
    );
  }
}
