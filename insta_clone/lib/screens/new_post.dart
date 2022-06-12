import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  File? _file;
  bool isVideo = false;
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethod().uploadPost(
          _captionController.text, _file!, uid, username, profImage, isVideo);
      if (res == "sucess") {
        setState(() {
          _isLoading = false;
          _file = null;
        });
        showSnackBar("Upload Successfule", context);
      } else {
        setState(() {
          _isLoading = false;
          _file = null;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create New Post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final file =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  File newImage = File(file!.path);
                  setState(() {
                    _file = newImage;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  // File newImage = File.fromRawPath(file);

                  File newImage = File(file!.path);
                  final type = (p.extension(newImage.path));
                  print(type);
                  setState(() {
                    isVideo = false;
                    _file = newImage;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose Video from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final file = await ImagePicker()
                      .pickVideo(source: ImageSource.gallery);
                  // File newImage = File.fromRawPath(file);

                  File newImage = File(file!.path);
                  final type = (p.extension(newImage.path));
                  print(type);
                  setState(() {
                    isVideo = true;
                    _file = newImage;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Go back"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: mobileBgColor,
                title: Text("New Post"),
                centerTitle: false,
                actions: [
                  IconButton(
                      onPressed: () =>
                          postImage(user.uid, user.username, user.photoUrl),
                      icon: Icon(
                        Icons.done,
                        color: blueColor,
                      ))
                ],
                leading: IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                  ),
                  onPressed: () {},
                )),
            body: Column(
              children: [
                _isLoading ? const LinearProgressIndicator() : Container(),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      child: CachedNetworkImage(imageUrl: user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 45,
                      child: TextField(
                        controller: _captionController,
                        decoration: InputDecoration(
                            hintText: "Write Caption",
                            border: InputBorder.none),
                        maxLines: 4,
                      ),
                    ),
                    SizedBox(
                        width: 45,
                        height: 45,
                        child: Container(
                          child: isVideo
                              ? Text("video")
                              : Image(image: FileImage(_file!)),
                        ))
                  ],
                )
              ],
            ),
          );
  }
}
