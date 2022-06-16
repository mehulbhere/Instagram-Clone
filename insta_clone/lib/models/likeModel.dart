import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String uid;
  final String postId;
  final String username;
  final dateOfPublish;
  final String profImage;

  const LikeModel({
    required this.uid,
    required this.postId,
    required this.username,
    required this.dateOfPublish,
    required this.profImage,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'dateOfPublish': dateOfPublish,
        'profImage': profImage,
        'postId': postId,
      };

  static LikeModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return LikeModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      dateOfPublish: snapshot['dateOfPublish'],
      profImage: snapshot['profImage'],
      postId: snapshot['postId'],
    );
  }

  static List<LikeModel> likesFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return LikeModel.fromSnap(doc);
    }).toList();
}
}
