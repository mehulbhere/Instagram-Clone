import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insta_clone/providers/theme_model.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/screens/post_card_view.dart';
import 'package:insta_clone/screens/showFollows.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/customProgess.dart';
import 'package:insta_clone/widgets/displayImage.dart';
import 'package:insta_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart' as model;

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
  var followers;
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
        print(currentUser + uid);
        print(userData['username']);
        print(snap.data()!['following']);
        followers = snap.data()!['following'];
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
    final model.User user = Provider.of<UserProvider>(context).getUser;
    setState(() {
      currentUser = user.uid;
      print("curre" + currentUser);
    });

    return isLoading
        ? Center(
            child: CustomProgess(),
          )
        : Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: currentUser != widget.uid
                    ? BackButton(
                        color: Theme.of(context).primaryColor,
                      )
                    : SizedBox(
                        width: 0,
                      ),
                actions: [
                  currentUser == widget.uid
                      ? IconButton(
                          color: Colors.grey,
                          icon: Icon(themeNotifier.isDark
                              ? Icons.nightlight_round
                              : Icons.wb_sunny),
                          onPressed: () {
                            themeNotifier.isDark
                                ? themeNotifier.isDark = false
                                : themeNotifier.isDark = true;
                          })
                      : SizedBox(height: 0)
                ],
                elevation: 0,
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text(
                  userData['username'],
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
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
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 15),
                        alignment: Alignment.center,
                        child: Text(
                          userData['bio'],
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowFollow(followList: followers))),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStat(postCount, "Posts"),
                              VerticalDivider(
                                color: Theme.of(context).primaryColor,
                              ),
                              buildStat(followersCount, "Followers"),
                              VerticalDivider(
                                color: Theme.of(context).primaryColor,
                              ),
                              buildStat(followingCount, "Following"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          currentUser == widget.uid
                              ? FollowButton(
                                  function: () async {
                                    await AuthMethod().signOut();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  bColor: Theme.of(context).primaryColorDark,
                                  bgColor: Theme.of(context).primaryColorDark,
                                  text: "Sign Out",
                                  textColor: Theme.of(context).primaryColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                )
                              : isFollowing
                                  ? FollowButton(
                                      function: () async {
                                        await FirestoreMethod()
                                            .follow(currentUser, widget.uid);
                                        setState(() {
                                          isFollowing = false;
                                          followersCount--;
                                        });
                                      },
                                      bColor:
                                          Theme.of(context).primaryColorDark,
                                      bgColor:
                                          Theme.of(context).primaryColorDark,
                                      text: "Unfollow",
                                      textColor: Theme.of(context).primaryColor,
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                    )
                                  : FollowButton(
                                      bColor: purpleColor,
                                      bgColor: blueColor,
                                      text: "Follow",
                                      function: () async {
                                        await FirestoreMethod()
                                            .follow(currentUser, widget.uid);
                                        setState(() {
                                          isFollowing = true;
                                          followersCount++;
                                        });
                                      },
                                      textColor:
                                          Theme.of(context).backgroundColor,
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                    )
                        ],
                      )
                    ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        alignment: Alignment.center,
                        onPressed: () {},
                        icon: Icon(Icons.grid_on_rounded),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark,
                          color: mobileAColor,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: mobilePColor,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: userData['uid'])
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CustomProgess());
                      } else if (snapshot.connectionState !=
                              ConnectionState.waiting &&
                          (snapshot.data! as dynamic).docs.length != 0) {
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
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => PostCardView(
                                                snap:
                                                    (snapshot.data! as dynamic)
                                                        .docs[index],
                                                title: "Posts",
                                              ))),
                                  child: DisplayImage(
                                      url: (snapshot.data! as dynamic)
                                          .docs[index]['postUrl']),
                                ));
                      } else {
                        return Center(
                            child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.photo,
                                size: 100,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Add new post",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 250,
                                alignment: Alignment.center,
                                child: Text(
                                  "Add new photos and videos, they'll appear on your profile",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                              ),
                            ],
                          ),
                        ));
                      }
                    },
                  )
                ],
              ),
            );
          });
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
