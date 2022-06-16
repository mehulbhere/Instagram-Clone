import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';

class CustomProgess extends StatelessWidget {
  const CustomProgess({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: mobilePColor,
      backgroundColor: mobileSecondaryColor,
      strokeWidth: 1,
    );
  }
}