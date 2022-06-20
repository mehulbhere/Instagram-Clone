import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/userTile.dart';

import '../widgets/customProgess.dart';

class DisplayLikes extends StatefulWidget {
  final String postId;
  final likeCount;
  const DisplayLikes({Key? key, required this.postId, required this.likeCount})
      : super(key: key);

  @override
  _DisplayLikesState createState() => _DisplayLikesState();
}

class _DisplayLikesState extends State<DisplayLikes> {
  bool isLoading = true;
  var likes;
  var listLikes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      if (widget.likeCount != 0)
        FirestoreMethod().getLikes(widget.postId).then((value) {
          setState(() {
            likes = value;
            print("likes: ${likes}");
            isLoading = false;
          });
        });
      else {
        isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CustomProgess())
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              foregroundColor: Theme.of(context).primaryColor,
              title: Text(
                "Likes",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            body: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "  ${widget.likeCount} likes",
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 20,
                  color: Theme.of(context).dividerColor,
                ),
                widget.likeCount == 0
                    ? Center(
                        child: Text("No likes"),
                      )
                    : FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .where("uid", whereIn: likes)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CustomProgess(),
                            );
                          } else if (snapshot.connectionState !=
                              ConnectionState.waiting) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                                uid: (snapshot.data! as dynamic)
                                                    .docs[index]['uid']))),
                                    child: UserTile(
                                      snap: (snapshot.data! as dynamic)
                                          .docs[index],
                                    ),
                                  );
                                });
                          } else {
                            return Text("Nothing to show");
                          }
                        },
                      ),
              ],
            ),
          );
  }
}
