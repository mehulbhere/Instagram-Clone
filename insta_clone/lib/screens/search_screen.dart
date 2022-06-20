import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/post_card_view.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';
import 'package:insta_clone/widgets/customProgess.dart';
import 'package:insta_clone/widgets/displayImage.dart';
import 'package:insta_clone/widgets/userTile.dart';

import '../widgets/postCard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  bool isSearch = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBgColor,
        title: Container(
          alignment: Alignment.center,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: mobileSecondaryColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              cursorColor: mobilePColor,
              cursorWidth: 1,
              textAlignVertical: TextAlignVertical.center,
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: "Search for username", border: InputBorder.none),
              onChanged: (String _) {
                setState(() {
                  if (_searchController.text == "") {
                    isSearch = false;
                  }
                  isSearch = true;
                });
              },
            ),
          ),
        ),
      ),
      body: isSearch
          ? RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where('username',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CustomProgess(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: (snapshot.data! as dynamic)
                                              .docs[index]['uid']))),
                              child: UserTile(
                                  snap:
                                      (snapshot.data! as dynamic).docs[index]));
                        });
                  }
                },
              ),
            )
          : RefreshIndicator(
              backgroundColor: mobileSecondaryColor,
              color: mobilePColor,
              strokeWidth: 1,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection("posts").get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CustomProgess(),
                      );
                    } else {
                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => PostCardView(
                                              snap: (snapshot.data! as dynamic)
                                                  .docs[index],
                                              title: "Explore",
                                            ))),
                                child: DisplayImage(
                                    url: (snapshot.data! as dynamic).docs[index]
                                        ['postUrl']),
                              ));
                    }
                  }),
            ),
    );
  }
}
