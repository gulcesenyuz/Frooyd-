import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;
  String username;
  String profilePhoto;
  String profession;
  List followers;
  List following;
  String bio;
  Map feed_posts;
  User(
      {this.uid,
      this.name,
      this.email,
      this.bio,
      this.username,
      this.profilePhoto,
      this.followers,
      this.following,
      this.profession,
      this.feed_posts});

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      uid: document.documentID,
      name: document['name'],
      bio: document['bio'],
      profession: document['profession'],
      email: document['email'],
      username: document['username'],
      profilePhoto: document['profilePhoto'],
      followers: document['followers'],
      following: document['following'],
      feed_posts: document['feed_posts'],
    );
  }
}
