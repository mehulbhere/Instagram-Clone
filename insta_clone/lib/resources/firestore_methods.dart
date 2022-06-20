import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/comment.dart';
import 'package:insta_clone/models/likeModel.dart';
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

  Future<void> likedPost(String postId, String uid, List likes, bool isAnimated,
      String username, String profImage) async {
    try {
      LikeModel like = LikeModel(
          uid: uid,
          postId: postId,
          username: username,
          dateOfPublish: DateTime.now(),
          profImage: profImage);
      if (likes.contains(uid) && !isAnimated) {
        //remove our uid from the list
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
        _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("likes")
            .doc(uid)
            .delete();
      } else {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
        _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("likes")
            .doc(uid)
            .set(like.toJson());
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

  Future<void> deletePost(String postId) async {
    String res = "error";
    try {
      await _firebaseFirestore.collection("posts").doc(postId).delete();
      print("deleted successfully");
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> follow(String uid, String followUid) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      print("Im following ${following}");
      print("Checking ${followUid} and ${uid}");
      if (following.contains(followUid)) {
        print("unfollwed ${followUid}");
        await _firebaseFirestore.collection("users").doc(followUid).update({
          'followers': FieldValue.arrayRemove([uid])
        }).then((value) => print("done"));
        await _firebaseFirestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([followUid])
        }).then((value) => print("done"));
      } else {
        print("followed ${followUid}");
        await _firebaseFirestore.collection("users").doc(followUid).update({
          'followers': FieldValue.arrayUnion([uid])
        }).then((value) => print("done"));
        await _firebaseFirestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([followUid])
        }).then((value) => print("done"));
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<List<String>> getLikes(String postId) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection("posts").doc(postId).get();
    List<String> likes = ((snap.data()! as dynamic)['likes'] as List)
        .map((e) => e as String)
        .toList();
    print(likes);
    return likes;
  }
}
