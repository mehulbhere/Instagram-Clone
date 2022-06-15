import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/postCard.dart';

class PostCardView extends StatefulWidget {
  final snap;
  final String title;
  const PostCardView({Key? key, required this.snap, required this.title})
      : super(key: key);

  @override
  _PostCardViewState createState() => _PostCardViewState();
}

class _PostCardViewState extends State<PostCardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBgColor,
        toolbarHeight: kToolbarHeight,
        title: Text(widget.title),
      ),
      body: PostCard(snap: widget.snap),
    );
  }
}
