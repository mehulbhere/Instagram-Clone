import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBgColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(snap['profImage']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    snap['username'],
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
        ),
        SizedBox(
            // height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Image.network(snap['postUrl'])),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.mode_comment_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.ios_share_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border_outlined),
                onPressed: () {},
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 15,
                                ),
                                Text(
                                  snap['likes'].length.toString() + " likes",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.mode_comment,
                                  size: 15,
                                ),
                                Text(
                                  snap['comments'].length.toString() +
                                      " comments",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ]),
                    )),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, right: 10),
            child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: snap['username'] + " ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: snap['caption'])
                ])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Text(
            DateFormat.yMMMd().format(snap['dateOfPublish'].toDate()),
            style: TextStyle(fontWeight: FontWeight.w400, color: mobileAColor),
          ),
        )
      ]),
    );
  }
}
