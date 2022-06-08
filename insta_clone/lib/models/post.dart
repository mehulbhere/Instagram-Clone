import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String postId;
  final String username;
  final dateOfPublish;
  final String postUrl;
  final String profImage;

  const Post({
    required this.caption,
    required this.uid,
    required this.postId,
    required this.username,
    required this.dateOfPublish,
    required this.postUrl,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'caption': caption,
        'dateOfPublish': dateOfPublish,
        'postUrl': postUrl,
        'profImage': profImage,
        'postId': postId
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      caption: snapshot['caption'],
      dateOfPublish: snapshot['dateOfPublish'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      postId: snapshot['postId'],
    );
  }
}
