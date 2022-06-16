import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/likeModel.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/customProgess.dart';
import 'package:insta_clone/widgets/displayImage.dart';
import 'package:intl/intl.dart';

import '../models/post.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  List<LikeModel> likes = [];
  List<Post> posts = [];
  void getActivity() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("posts")
        .doc(currentUser)
        .collection("likes")
        .get();

    var post = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: currentUser)
        .get();

    print(post.docs.length);
    for (var post in post.docs) {
      var singlePost = await post.reference.collection("likes").get();
      posts.add(Post.fromSnap(post));
      for (var liked in singlePost.docs) {
        likes.add(LikeModel.fromSnap(liked));
      }
    }
    print(likes.length);
    print(posts.length);
    setState(() {
      (likes.sort((b, a) => a.dateOfPublish.compareTo(b.dateOfPublish)));
      isLoading = false;
    });
    // likes = LikeModel.likesFromSnap(snapshot);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        title: Text("Activity"),
        backgroundColor: mobileBgColor,
      ),
      body: isLoading
          ? Center(child: CustomProgess())
          : ListView.builder(
              itemCount: likes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    height: kToolbarHeight * 0.75,
                    width: kToolbarHeight * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              likes[index].profImage)),
                    ),
                  ),
                  title: Text("${likes[index].username} liked your post"),
                  subtitle: Text(getTime(likes[index].dateOfPublish)),
                  trailing: Container(
                    height: kToolbarHeight * 0.75,
                    width: kToolbarHeight * 0.75,
                    child: DisplayImage(url: getPostImage(likes[index].postId)),
                  ),
                );
              }),
    );
  }

  getPostImage(String postId) {
    for (var post in posts) {
      if (post.postId == postId) {
        return post.postUrl;
      }
    }
  }

  String getTime(time) {
    Timestamp postStamp = (time);
    DateTime postTime = postStamp.toDate();
    DateTime currTime = DateTime.now();
    String timeStr = "";
    print("${postTime.day} > ${currTime.day}");
    if (postTime.day < currTime.day) {
      timeStr = DateFormat.yMMMd().format(time.toDate());
    } else {
      timeStr = currTime.hour - postTime.hour > 0
          ? (currTime.hour - postTime.hour).toString() + " hrs ago"
          : (currTime.minute - postTime.minute).toString() + " mins ago";
    }
    return timeStr;
  }
}
