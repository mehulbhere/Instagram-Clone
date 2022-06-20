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
  const DisplayLikes({Key? key, required this.postId}) : super(key: key);

  @override
  _DisplayLikesState createState() => _DisplayLikesState();
}

class _DisplayLikesState extends State<DisplayLikes> {
  bool isLoading = true;
  var likes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      FirestoreMethod().getLikes(widget.postId).then((value) {
        setState(() {
          likes = value;
          print("likes: ${likes}");
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CustomProgess())
        : Scaffold(
            appBar: AppBar(
              title: Text("Likes"),
              backgroundColor: mobileBgColor,
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
                          "  ${likes.length} likes",
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 20,
                  color: mobilePColor,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .where("uid", whereIn: likes)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CustomProgess(),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: (snapshot.data! as dynamic)
                                              .docs[index]['uid']))),
                              child: UserTile(
                                snap: (snapshot.data! as dynamic).docs[index],
                              ),
                            );
                          });
                    }
                  },
                ),
              ],
            ),
          );
  }
}
