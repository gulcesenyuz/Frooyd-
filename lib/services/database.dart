import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userID;

  uploadPsiInfo(psiMap) async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    Firestore.instance
        .collection("psikologlar")
        .document(userID)
        .setData(psiMap)
        .catchError((e) {
      print(e.toString());
    });
    print("------psikolog-------");
    print(userID);
  }

  uploadUserInfo(userMap) async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    Firestore.instance
        .collection("users")
        .document(userID)
        .setData(userMap)
        .catchError((e) {
      print(e.toString());
    });
    print("-------user------");
    print(userID);
  }

  Future<String> uploadImagePsy(File imageFile) async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    // String fileName= basename(imageFile.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child("Psikolog/profile/${user.uid}");
    StorageUploadTask task = ref.putFile(imageFile);
    StorageTaskSnapshot snapshot = await task.onComplete;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    await Firestore.instance
        .collection("psikologlar")
        .document(userID)
        .updateData({
      'picUrl': downloadUrl,
    });
    return 'done';
  }

  Future uploadCVPsy(File file) async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    // String fileName= basename(imageFile.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child("Psikolog/CV/${user.uid}");
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    await Firestore.instance
        .collection("psikologlar")
        .document(userID)
        .updateData({
      'CV': downloadUrl,
    });
    return;
  }

  Future<String> uploadImageUser(File imageFile) async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;

    // String fileName= basename(imageFile.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child("User/profile/${user.uid}");
    StorageUploadTask task = ref.putFile(imageFile);
    StorageTaskSnapshot snapshot = await task.onComplete;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    await Firestore.instance.collection("users").document(userID).updateData({
      'picUrl': downloadUrl,
    });
    return 'done';
  }

  uploadFollowed(followedPsiUid) async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    Firestore.instance
        .collection("followed")
        .document(userID)
        .setData(followedPsiUid)
        .catchError((e) {
      print(e.toString());
    });
    print("-------followed_psi------");
    print(userID);
  }

  Future<List> addSplitData(searchIndex) async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    Firestore.instance.collection('psikologlar').document(userID).updateData({
      'searchIndex': searchIndex,
    });

    return null;
  }

  updatePsiInfo() async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    Firestore.instance
        .collection('psikologlar')
        .document(userID)
        .updateData({"userUid": userID}).then((result) {
      print("new USer true");
    }).catchError((onError) {
      print("onError");
    });
  }
}
