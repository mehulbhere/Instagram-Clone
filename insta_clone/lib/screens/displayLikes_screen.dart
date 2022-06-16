import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';

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
              actions: [
                Icon(Icons.favorite),
                Center(
                  child: Text(
                    "  ${likes.length} likes",
                  ),
                )
              ],
              backgroundColor: mobileBgColor,
            ),
            body: FutureBuilder(
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
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid']))),
                          child: ListTile(
                            leading: Container(
                              height: kToolbarHeight * 0.75,
                              width: kToolbarHeight * 0.75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['photoUrl'])),
                              ),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ['username']),
                          ),
                        );
                      });
                }
              },
            ),
          );
  }
}
