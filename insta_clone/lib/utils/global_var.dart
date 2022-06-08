import 'package:flutter/material.dart';
import 'package:insta_clone/screens/new_post.dart';

const webScreenSize = 600;

const tabs = [
  Center(child: Text("Home")),
  Center(child: Text("Search")),
  NewPost(),
  Center(child: Text("Likes")),
  Center(child: Text("Profile")),
];

const sampleImage =
    "https://images.unsplash.com/photo-1654302846461-aca08433cfda?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80";

double getWidth(context) {
  return MediaQuery.of(context).size.width;
}
