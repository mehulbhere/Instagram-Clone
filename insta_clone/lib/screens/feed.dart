import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/customProgess.dart';
import 'package:insta_clone/widgets/postCard.dart';

import '../models/post.dart';

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
    Stream<QuerySnapshot<Map<String, dynamic>>> stream =
        db.collection("posts").snapshots(includeMetadataChanges: true);
    db
        .collection("posts")
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: mobileBgColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: mobilePColor,
          height: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.paperplane,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: mobileSecondaryColor,
        color: mobilePColor,
        strokeWidth: 1,
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder(
          stream: getStream(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgess());
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  PostCard(snap: snapshot.data!.docs[index].data()),
            );
          },
        ),
      ),
    );
  }
}
