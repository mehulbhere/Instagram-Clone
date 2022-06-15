import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  var userData = {};
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  bool isLoading = false;
  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();
      setState(() {
        postCount = postSnap.docs.length;
        userData = snap.data()!;
        followersCount = snap.data()!['followers'].length;
        followingCount = snap.data()!['following'].length;
        isFollowing = snap.data()!['followers'].contains(currentUser);
        print(userData);
        print(userData['username']);
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBgColor,
              title: Text(userData['username']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Container(
                          height: kToolbarHeight * 1.5,
                          width: kToolbarHeight * 1.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    userData['photoUrl'])),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStat(postCount, "Posts"),
                              buildStat(followersCount, "Followers"),
                              buildStat(followingCount, "Following"),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData['username'],
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData['bio'],
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentUser == widget.uid
                            ? FollowButton(
                                bColor: mobileAColor,
                                bgColor: mobileAColor,
                                text: "Edit Profile",
                                textColor: mobilePColor,
                                width: MediaQuery.of(context).size.width * 0.75,
                              )
                            : isFollowing
                                ? FollowButton(
                                    bColor: mobileAColor,
                                    bgColor: mobileAColor,
                                    text: "Unfollow",
                                    textColor: mobilePColor,
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                  )
                                : FollowButton(
                                    bColor: blueColor,
                                    bgColor: blueColor,
                                    text: "Follow",
                                    textColor: mobilePColor,
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                  )
                      ],
                    )
                  ]),
                ),
                Divider(
                  color: mobilePColor,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where("uid", isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) => CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: (snapshot.data! as dynamic).docs[index]
                                  ['postUrl']));
                    }
                  },
                )
              ],
            ),
          );
  }

  Column buildStat(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        Text(label, style: TextStyle(fontWeight: FontWeight.w300)),
      ],
    );
  }
}
