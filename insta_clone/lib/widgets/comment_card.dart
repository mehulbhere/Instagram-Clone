import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/global_var.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(children: [
        Container(
          height: kToolbarHeight * 0.75,
          width: kToolbarHeight * 0.75,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(widget.snap['profImage']))),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${widget.snap['username']} ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                  TextSpan(
                      text: "${widget.snap['commentText']}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColor)),
                ])),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['dateOfPublish'].toDate()),
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "100 likes",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      Text(
                        "Reply",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child:
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
        )
      ]),
    );
  }
}
