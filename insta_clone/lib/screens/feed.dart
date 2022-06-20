import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/customProgess.dart';
import 'package:insta_clone/widgets/displayImage.dart';
import 'package:insta_clone/widgets/postCard.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../widgets/story_avatar.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //caching
  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    print("Fecthing..............................");
    db.settings = Settings(persistenceEnabled: true);
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = db
        .collection("posts")
        .orderBy('dateOfPublish', descending: true)
        .snapshots(includeMetadataChanges: true);
    db
        .collection("posts")
        .orderBy('dateOfPublish', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          print("local storage");
        }
      }
    });
    return stream;
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.camera,
              color: Theme.of(context).primaryColor,
            )),
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          alignment: Alignment.bottomCenter,
          color: Theme.of(context).primaryColor,
          height: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.paperplane,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).backgroundColor,
        color: Theme.of(context).primaryColor,
        strokeWidth: 1,
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                child: Row(
                  children: [
                    Stack(children: [
                      StoryAvatar(user: user),
                      Positioned(
                          bottom: 5,
                          right: -10,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.add_circled_solid,
                                color: blueColor,
                              ))),
                      Positioned(
                          bottom: 5,
                          right: -10,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.add_circled,
                                  color: Colors.white)))
                    ])
                  ],
                ),
              ),
              StreamBuilder(
                stream: getStream(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CustomProgess());
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                        PostCard(snap: snapshot.data!.docs[index].data()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
