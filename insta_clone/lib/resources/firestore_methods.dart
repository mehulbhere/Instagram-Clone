import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/comment.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/resources/storage_methods.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String caption, File file, String uid,
      String username, String profileImage, bool isVideo) async {
    String res = "Error";
    try {
      String photoUrl;
      if (isVideo) {
        photoUrl =
            await StorageMethod().uploadVideoToStorage("posts", file, true);
      } else {
        photoUrl =
            await StorageMethod().uploadFileToStorage("posts", file, true);
      }
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
          comments: [],
          isVideo: isVideo);

      _firebaseFirestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
      return res;
    } catch (err) {
      res = err.toString();
      return res;
    }
  }

  Future<void> likedPost(
      String postId, String uid, List likes, bool isAnimated) async {
    try {
      if (likes.contains(uid) && !isAnimated) {
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

  Future<void> postComment(String postId, String text, String uid,
      String username, String profImage) async {
    String res = "error";
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        Comment newComment = Comment(
            commentText: text,
            uid: uid,
            postId: postId,
            username: username,
            dateOfPublish: DateTime.now(),
            profImage: profImage);
        _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(newComment.toJson());
        res = "success";
        print(res);
      } else {
        res = "empty comment";
        print(res);
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletePost(String postId)async{
    String res = "error";
    try{
      await _firebaseFirestore.collection("posts").doc(postId).delete();
      print("deleted successfully");
    }catch(err){
      print(err.toString());
    }
  }
}
