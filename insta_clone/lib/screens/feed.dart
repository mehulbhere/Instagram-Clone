import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/posts.dart';

import '../models/post.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBgColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: mobilePColor,
          height: 40,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.send,
              size: 30,
            ),
          )
        ],
      ),
      body: PostCard(),
    );
  }
}
