import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class DisplayImage extends StatelessWidget {
  final url;
  const DisplayImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Center(
              child: Shimmer.fromColors(
                  child:
                      Container(decoration: BoxDecoration(color: Colors.white)),
                  baseColor: Color(0x30ffffff),
                  highlightColor: Color(0x70ffffff)));
        },
      ),
    );
  }
}
