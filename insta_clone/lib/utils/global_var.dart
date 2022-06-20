import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/new_post.dart';
import 'package:insta_clone/screens/notification_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/search_screen.dart';

import '../screens/feed.dart';

const webScreenSize = 600;
String uid = FirebaseAuth.instance.currentUser!.uid;
final tabs = [
  Feed(),
  SearchScreen(),
  NewPost(),
  ActivityScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

const sampleImage =
    "https://images.unsplash.com/photo-1654302846461-aca08433cfda?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80";

double getWidth(context) {
  return MediaQuery.of(context).size.width;
}
