import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/screens/comment_screen.dart';
import 'package:insta_clone/screens/displayLikes_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/displayImage.dart';
import 'package:insta_clone/widgets/displayVideo.dart';
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
  int commentsCount = 0;
  int likesCount = 0;
  bool isLiked = false;

  void getCommentCount() async {
    try {
      QuerySnapshot commentSnap = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      QuerySnapshot likeSnap = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap['postId'])
          .collection('likes')
          .get();
      setState(() {
        commentsCount = commentSnap.docs.length;
        likesCount = likeSnap.docs.length;
      });
      print("got comment count");
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    setState(() {
      isLiked = widget.snap['likes'].contains(user.uid);
    });
    return Container(
      color: mobileBgColor,
      padding: EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: DisplayImage(url: widget.snap['profImage'])),
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
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return (SimpleDialog(
                            backgroundColor: mobileSecondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text("Options"),
                            children: [
                              SimpleDialogOption(
                                child: Text("Delete Post"),
                                onPressed: () async {
                                  FirestoreMethod()
                                      .deletePost(widget.snap['postId']);
                                  Navigator.of(context).pop();
                                  showSnackBar(
                                      "Post Deleted Successfully", context);
                                },
                              )
                            ],
                          ));
                        });
                  },
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                  )),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethod().likedPost(widget.snap['postId'], user.uid,
                widget.snap['likes'], true, user.username, user.photoUrl);
            getCommentCount();
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: widget.snap['isVideo']
                  ? DisplayVideo(snap: widget.snap)
                  : DisplayImage(url: widget.snap['postUrl']),
            ),
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
                  icon: isLiked
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                  onPressed: () async {
                    await FirestoreMethod().likedPost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes'],
                        false,
                        user.username,
                        user.photoUrl);
                    getCommentCount();
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                icon: Icon(CupertinoIcons.chat_bubble),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(snap: widget.snap))),
              ),
              IconButton(
                icon: Icon(CupertinoIcons.paperplane),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border_outlined),
                onPressed: () {},
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DisplayLikes(postId: widget.snap['postId']))),
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
                                    " ${likesCount} likes",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    CupertinoIcons.chat_bubble,
                                    size: 15,
                                  ),
                                  Text(
                                    " ${commentsCount} comments",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ]),
                      ),
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
            getPostTime(widget.snap['dateOfPublish']),
            style:
                TextStyle(fontWeight: FontWeight.normal, color: mobileAColor),
          ),
        ),
        Divider(
          color: mobileAColor,
        )
      ]),
    );
  }
}
