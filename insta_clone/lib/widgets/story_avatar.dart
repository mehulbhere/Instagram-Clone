import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/displayImage.dart';

import '../models/user.dart';

class StoryAvatar extends StatefulWidget {
  final User user;
  const StoryAvatar({Key? key, required this.user}) : super(key: key);

  @override
  _StoryAvatarState createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<StoryAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 5,
      child: Column(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width / 10,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: DisplayImage(url: widget.user.photoUrl)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Your Story",
            style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    );
  }
}
