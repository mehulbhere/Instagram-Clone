import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentText;
  final String uid;
  final String postId;
  final String username;
  final dateOfPublish;
  final String profImage;

  const Comment({
    required this.commentText,
    required this.uid,
    required this.postId,
    required this.username,
    required this.dateOfPublish,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'commentText': commentText,
        'dateOfPublish': dateOfPublish,
        'profImage': profImage,
        'postId': postId,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      username: snapshot['username'],
      uid: snapshot['uid'],
      commentText: snapshot['commentText'],
      dateOfPublish: snapshot['dateOfPublish'],
      profImage: snapshot['profImage'],
      postId: snapshot['postId'],
    );
  }
}
