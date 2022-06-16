import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';
import 'package:insta_clone/widgets/comment_card.dart';
import 'package:insta_clone/widgets/customProgess.dart';
import 'package:insta_clone/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    print("Fecthing..............................");
    db.settings = Settings(persistenceEnabled: true);
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = db
        .collection("posts")
        .doc(widget.snap['postId'])
        .collection('comments')
        .orderBy('dateOfPublish', descending: true)
        .snapshots(includeMetadataChanges: true);
    db
        .collection("posts")
        .doc(widget.snap['postId'])
        .collection('comments')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          print("comments local storage");
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
        title: Text("Comments"),
        centerTitle: false,
        backgroundColor: mobileBgColor,
      ),
      body: StreamBuilder(
        stream: getStream(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomProgess());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                CommentCard(snap: snapshot.data!.docs[index].data()),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(children: [
          Container(
            height: kToolbarHeight * 0.75,
            width: kToolbarHeight * 0.75,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(user.photoUrl))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter comment as ${user.username}",
                ),
                controller: _commentController,
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                await FirestoreMethod().postComment(
                    widget.snap['postId'],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl);
                setState(() {
                  _commentController.text = "";
                });
              },
              icon: Icon(
                Icons.done,
                color: blueColor,
              ))
        ]),
      )),
    );
  }
}
