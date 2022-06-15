import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    //ref : path or pointer to the file
    //child: relative path
    //childName: folder name - Eg.Profile Pics

    Reference ref = _firebaseStorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);
    print("no post" + ref.toString());

    if (isPost) {
      String id = Uuid().v1();
      print("before" + ref.toString());
      ref = ref.child(id);
      print("after" + ref.toString());
    }
    //putData: upload a file in format Uint8List
    UploadTask uploadTask = ref.putData(file);
    //snapshot: result or on-going process
    TaskSnapshot snap = await uploadTask;
    //get the URL of the location of file
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadFileToStorage(
      String childName, File file, bool isPost) async {
    //ref : path or pointer to the file
    //child: relative path
    //childName: folder name - Eg.Profile Pics

    Reference ref = _firebaseStorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);
    print("no post" + ref.toString());

    if (isPost) {
      String id = Uuid().v1();
      print("before" + ref.toString());
      ref = ref.child(id);
      print("after" + ref.toString());
    }
    //putData: upload a file in format Uint8List
    UploadTask uploadTask = ref.putFile(file);
    //snapshot: result or on-going process
    TaskSnapshot snap = await uploadTask;
    //get the URL of the location of file
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadVideoToStorage(
      String childName, File file, bool isPost) async {
    //ref : path or pointer to the file
    //child: relative path
    //childName: folder name - Eg.Profile Pics

    Reference ref = _firebaseStorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);
    print("no post" + ref.toString());

    if (isPost) {
      String id = Uuid().v1();
      print("before" + ref.toString());
      ref = ref.child(id);
      print("after" + ref.toString());
    }
    //putData: upload a file in format Uint8List
    UploadTask uploadTask =
        ref.putFile(file, SettableMetadata(contentType: "video/mp4"));
    //snapshot: result or on-going process
    TaskSnapshot snap = await uploadTask;
    //get the URL of the location of file
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
