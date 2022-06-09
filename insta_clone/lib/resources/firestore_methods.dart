import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Error";
    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          caption: caption,
          uid: uid,
          username: username,
          postId: postId,
          dateOfPublish: DateTime.now(),
          postUrl: photoUrl,
          profImage: profileImage,
          likes: [],
          comments: []);

      _firebaseFirestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
      return res;
    } catch (err) {
      res = err.toString();
      return res;
    }
  }

  Future<void> likedPost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        //remove our uid from the list
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {}
  }
}
