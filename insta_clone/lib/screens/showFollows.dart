import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/widgets/customProgess.dart';

import '../widgets/userTile.dart';

class ShowFollow extends StatefulWidget {
  final followList;
  const ShowFollow({Key? key, required this.followList}) : super(key: key);

  @override
  State<ShowFollow> createState() => _ShowFollowState();
}

class _ShowFollowState extends State<ShowFollow> {
  bool isLoading = true;
  var followings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowings();
  }

  getFollowings() async {
    followings = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", whereIn: widget.followList)
        .get();
    setState(() {
      print(followings.docs.length);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
        title: Text("Following"),
      ),
      body: isLoading
          ? Center(child: CustomProgess())
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: followings.docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(uid: followings.docs[index]['uid']))),
                  child: UserTile(
                    snap: followings.docs[index],
                  ),
                );
              }),
    );
  }
}
