import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/follow_button.dart';

class UserTile extends StatefulWidget {
  final snap;
  const UserTile({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;
  bool isFollowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isFollowing = widget.snap['followers'].contains(currentUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: kToolbarHeight * 0.75,
        width: kToolbarHeight * 0.75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              (widget.snap['photoUrl']),
            ),
          ),
        ),
      ),
      title: Text(
        widget.snap['username'],
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width / 3,
        child: widget.snap['uid'] == currentUser
            ? Container()
            : isFollowing
                ? Row(
                    children: [
                      FollowButton(
                        bColor: mobileSecondaryColor,
                        bgColor: mobileSecondaryColor,
                        text: "Following",
                        textColor: mobilePColor,
                        width: MediaQuery.of(context).size.width,
                        function: () async {
                          await FirestoreMethod()
                              .follow(currentUser, widget.snap['uid']);
                          setState(() {
                            isFollowing = false;
                          });
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      FollowButton(
                        bColor: purpleColor,
                        bgColor: blueColor,
                        text: "Follow",
                        textColor: mobilePColor,
                        width: MediaQuery.of(context).size.width,
                        function: () async {
                          await FirestoreMethod()
                              .follow(currentUser, widget.snap['uid']);
                          setState(() {
                            isFollowing = true;
                          });
                        },
                      ),
                    ],
                  ),
      ),
    );
  }
}
