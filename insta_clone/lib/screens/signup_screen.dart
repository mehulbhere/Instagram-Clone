import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_field_input.dart';
import 'dart:typed_data';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose(); // TODO: implement dispose
    _usernameController.dispose(); // TODO: implement dispose
    _bioController.dispose(); // TODO: implement dispose
    super.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().signUpUser(
        email: _emailController.text,
        password: _passController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    print(res);
    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout())));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: mobilePColor,
              height: 64,
            ),
            SizedBox(height: 24),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : CircleAvatar(
                        radius: 64,
                        child: CachedNetworkImage(imageUrl:
                            "https://images.unsplash.com/photo-1654302846461-aca08433cfda?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
                      ),
                Positioned(
                    bottom: -10,
                    right: -10,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo_rounded)))
              ],
            ),
            SizedBox(height: 24),
            TextFieldInput(
                hintText: "Enter Email",
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress),
            SizedBox(height: 24),
            TextFieldInput(
              hintText: "Enter Password",
              textEditingController: _passController,
              textInputType: TextInputType.text,
              isPass: true,
            ),
            SizedBox(height: 24),
            TextFieldInput(
                hintText: "Enter Username",
                textEditingController: _usernameController,
                textInputType: TextInputType.text),
            SizedBox(height: 24),
            TextFieldInput(
                hintText: "Enter Bio",
                textEditingController: _bioController,
                textInputType: TextInputType.text),
            SizedBox(height: 24),
            GestureDetector(
              onTap: signUpUser,
              child: Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: mobilePColor,
                        ))
                      : Text("Sign Up"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      color: blueColor)),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: Text("Already have an account? "),
                    padding: EdgeInsets.symmetric(vertical: 10)),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Container(
                      child: Text(
                        " Log In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10)),
                )
              ],
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
          ],
        ),
      )),
    );
  }
}
