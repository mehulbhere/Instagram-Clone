import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with AutomaticKeepAliveClientMixin {
  //To avoid pages to reload on tab switch
  @override
  bool get wantKeepAlive => true;

  String _username = "";
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    getUsername();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _username = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  //Handling navigation

  int _page = 0;
  void navigate(int page) {
    pageController.jumpToPage(page);
  }

  void pageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: tabs,
          physics:
              NeverScrollableScrollPhysics(), //Cannot scroll to switch tabs
          controller: pageController,
          onPageChanged: pageChange, //Change the page on tap
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 45,
        child: BottomNavigationBar(
          iconSize: 25,
          selectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: true,
          backgroundColor: mobileBgColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                  color: _page == 0 ? mobilePColor : mobileAColor,
                ),
                label: "",
                backgroundColor: mobileBgColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_outlined,
                  color: _page == 1 ? mobilePColor : mobileAColor,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_box_outlined,
                  color: _page == 2 ? mobilePColor : mobileAColor,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: _page == 3 ? mobilePColor : mobileAColor,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: _page == 4 ? mobilePColor : mobileAColor,
                ),
                label: ""),
          ],
          onTap: navigate,
        ),
      ),
    );
  }
}
