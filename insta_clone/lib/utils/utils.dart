import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:video_player/video_player.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No image");
}

showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: mobilePColor),
    ),
    backgroundColor: Color(0xee444444),
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    action: SnackBarAction(
      label: "Dismiss",
      textColor: blueColor,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  ));

  
}
CircularProgressIndicator customCircularProgressIndicator() {
    return CircularProgressIndicator(
      color: mobilePColor,
      backgroundColor: mobileSecondaryColor,
      strokeWidth: 1,
    );
  }
