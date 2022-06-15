import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_var.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(hintText: "Search for username"),
          onFieldSubmitted: (String _) {
            setState(() {
              isSearch = true;
            });
          },
        ),
      ),
      body: isSearch
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
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
                          child: ListTile(
                            leading: Container(
                              height: kToolbarHeight * 0.75,
                              width: kToolbarHeight * 0.75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['photoUrl'])),
                              ),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ['username']),
                          ),
                        );
                      });
                }
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // return StaggeredGridView.countBuilder(
                  //     crossAxisCount: 3,
                  //     itemCount: (snapshot.data! as dynamic).docs.length,
                  //     itemBuilder: (context, index) => CachedNetworkImage(
                  //         imageUrl:
                  //             (snapshot.data! as dynamic).docs.data['postUrl']),
                  //     staggeredTileBuilder: (index) => StaggeredTile.count(
                  //         (index % 7 == 0) ? 2 : 3, (index % 7 == 0) ? 2 : 3));
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: (snapshot.data! as dynamic).docs[index]
                              ['postUrl']));
                }
              }),
    );
  }
}
