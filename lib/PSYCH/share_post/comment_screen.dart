// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import "dart:async";
//  //for current user
//
// class CommentScreen extends StatefulWidget {
//   final String postId;
//   final String postOwner;
//   final String postMediaUrl;
//
//   const CommentScreen({this.postId, this.postOwner, this.postMediaUrl});
//   @override
//   _CommentScreenState createState() => _CommentScreenState(
//       postId: this.postId,
//       postOwner: this.postOwner,
//       postMediaUrl: this.postMediaUrl);
// }
//
// class _CommentScreenState extends State<CommentScreen> {
//
//   final FirebaseAuth _auth =  FirebaseAuth.instance;
//
//   final String postId;
//   final String postOwner;
//   final String postMediaUrl;
//
//   bool didFetchComments = false;
//   List<Comment> fetchedComments = [];
//
//   final TextEditingController _commentController = TextEditingController();
//
//   _CommentScreenState({this.postId, this.postOwner, this.postMediaUrl});
//
//   String userID;
//   String name;
//   String username;
//   String picture;
//
//   void getProfileData() async{
//     try{
//       print ("test");
//       FirebaseUser user = await _auth.currentUser();
//       userID= user.uid;
//       DocumentSnapshot doc= await Firestore.instance.collection("users").document(user.uid).get();
//       setState(() {
//         name= doc.data["name"];
//         username= doc.data["username"];
//         picture=doc.data["picUrl"];
//       });
//     }catch (e){
//       print("error2");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Comments",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: buildPage(),
//     );
//   }
//
//   Widget buildPage() {
//     return Column(
//       children: [
//         Expanded(
//           child:
//           buildComments(),
//         ),
//         Divider(),
//         ListTile(
//           title: TextFormField(
//             controller: _commentController,
//             decoration: InputDecoration(labelText: 'Write a comment...'),
//             onFieldSubmitted: addComment,
//           ),
//           trailing: OutlineButton(onPressed: (){addComment(_commentController.text);}, borderSide: BorderSide.none, child: Text("Post"),),
//         ),
//       ],
//     );
//   }
//
//
//   Widget buildComments() {
//     if (this.didFetchComments == false){
//       return FutureBuilder<List<Comment>>(
//           future: getComments(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData)
//               return Container(
//                   alignment: FractionalOffset.center,
//                   child: CircularProgressIndicator());
//
//             this.didFetchComments = true;
//             this.fetchedComments = snapshot.data;
//             return ListView(
//               children: snapshot.data,
//             );
//           });
//     } else {
//       // for optimistic updating
//       return ListView(
//           children: this.fetchedComments
//       );
//     }
//   }
//
//   Future<List<Comment>> getComments() async {
//     List<Comment> comments = [];
//
//     QuerySnapshot data = await Firestore.instance
//         .collection("feed_posts_comments")
//         .document(postId)
//         .collection("comments")
//         .getDocuments();
//     data.documents.forEach((DocumentSnapshot doc) {
//       comments.add(Comment.fromDocument(doc));
//     });
//     return comments;
//   }
//
//   addComment(String comment) {
//     _commentController.clear();
//     Firestore.instance
//         .collection("feed_posts_comments")
//         .document(postId)
//         .collection("comments")
//         .add({
//       "username": username,
//       "comment": comment,
//       "timestamp": Timestamp.now(),
//       "avatarUrl": picture,
//       "userId": userID
//     });
//
//     //adds to postOwner's activity feed
//     Firestore.instance
//         .collection("feed")
//         .document(postOwner)
//         .collection("items")
//         .add({
//       "username": username,
//       "userId": userID,
//       "type": "comment",
//       "userProfileImg": picture,
//       "commentData": comment,
//       "timestamp": Timestamp.now(),
//       "postId": postId,
//       "mediaUrl": postMediaUrl,
//     });
//
//     // add comment to the current listview for an optimistic update
//     setState(() {
//       fetchedComments = List.from(fetchedComments)..add(Comment(
//           username: username,
//           comment: comment,
//           timestamp: Timestamp.now(),
//           avatarUrl: picture,
//           userId: userID
//       ));
//     });
//   }
// }
//
// class Comment extends StatelessWidget {
//   final String username;
//   final String userId;
//   final String avatarUrl;
//   final String comment;
//   final Timestamp timestamp;
//
//   Comment(
//       {this.username,
//         this.userId,
//         this.avatarUrl,
//         this.comment,
//         this.timestamp});
//
//   factory Comment.fromDocument(DocumentSnapshot document) {
//     return Comment(
//       username: document['username'],
//       userId: document['userId'],
//       comment: document["comment"],
//       timestamp: document["timestamp"],
//       avatarUrl: document["avatarUrl"],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         ListTile(
//           title: Text(comment),
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(avatarUrl),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
