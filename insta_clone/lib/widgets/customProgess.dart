import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';

class CustomProgess extends StatelessWidget {
  const CustomProgess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).backgroundColor,
      strokeWidth: 1,
    );
  }
}
