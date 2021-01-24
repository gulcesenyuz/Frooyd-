import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/profile_picture/profile_picture.dart';
import 'package:frooyd/MODEL/user.dart';
import 'package:frooyd/PSYCH/psy_top_bar/psikolog_topBar.dart';

class PsikologProfil extends StatefulWidget {
  final String uid;
  const PsikologProfil(this.uid);
  @override
  _PsikologProfilState createState() => _PsikologProfilState();
}

class _PsikologProfilState extends State<PsikologProfil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = "Name";
  String username = "Username";
  String picture = "";
  String profession = "Profession";
  String userID = "";
  String currentID = "";
  String userProfileImg = "";

  @override
  initState() {
    getProfileData();
    super.initState();
  }

  void getProfileData() async {
    try {
      print("test");
      FirebaseUser user = await _auth.currentUser();
      currentID = user.uid;
      DocumentSnapshot doc = await Firestore.instance
          .collection("psikologlar")
          .document(widget.uid)
          .get();
      setState(() {
        userID = doc.data["userUid"];
        name = doc.data["name"];
        username = doc.data["username"];
        picture = doc.data["picUrl"];
        profession = doc.data["profession"];
      });
    } catch (e) {
      print("error2");
    }
  }

  bool isFollowing = false;
  bool followButtonClicked = false;
  int followerCount = 0;
  int followingCount = 0;

  followUser() async {
    print('followUser');
    print(userID);
    print('hello');
    print(currentID);

    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });

//********************************************************************************************************************************  değişecek  */
    // firebase yok

    DocumentReference docRef =
        Firestore.instance.collection('psikologlar').document(userID);
    DocumentSnapshot doc = await docRef.get();
    List followers = doc.data['followers'];
    if (followers.contains(currentID) == false) {
      docRef.updateData({
        'followers': FieldValue.arrayUnion([currentID])
      });
    }

    DocumentReference documentReference =
        Firestore.instance.collection('users').document(currentID);
    DocumentSnapshot document = await docRef.get();
    List following = document.data['following'];
    if (following.contains(userID) == false) {
      documentReference.updateData({
        'following': FieldValue.arrayUnion([userID])
      });
    }
/*
    //updates activity feed
    Firestore.instance
        .collection("users")
        .document(currentID)
        .collection("following")
        .document(userID)
        .setData({
      "ownerId": userID,
      "username": username,
      "userId": currentID,
      "type": "follow",
      "userProfileImg": picture,
      "timestamp": DateTime.now()
    });
    */
  }

  unfollowUser() async {
    print("unfollowUser");
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });

    DocumentReference docRef =
        Firestore.instance.collection('psikologlar').document(userID);
    DocumentSnapshot doc = await docRef.get();
    List followers = doc.data['followers'];
    if (followers.contains(currentID) == false) {
      docRef.updateData({
        'followers': FieldValue.arrayRemove([currentID])
      });
    }

    DocumentReference documentReference =
        Firestore.instance.collection('users').document(currentID);
    DocumentSnapshot document = await docRef.get();
    List following = document.data['following'];
    if (following.contains(userID) == false) {
      documentReference.updateData({
        'following': FieldValue.arrayRemove([userID])
      });
    }
    /* Firestore.instance
        .collection("users")
        .document(currentID)
        .collection("followed")
        .document(userID)
        .delete();*/
  }

  buildProfileFollowButton() {
    print("buildProfileFollowButton");
    if (isFollowing) {
      print("isFollowing");
      return buildFollowButton(
        text: "Takipten Çıkar",
        function: unfollowUser,
      );
    }

    if (!isFollowing) {
      print("!isFollowing");
      return buildFollowButton(
        text: "Takip Et",
        function: followUser,
      );
    }
  }

  Widget buildFollowButton({String text, Function function}) {
    return FlatButton(
      onPressed: function,
      child: Container(
        padding: EdgeInsets.only(top: 2.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add,
              size: 20,
              color: Colors.blueAccent,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Widget buildStatColumn(IconData icon, int number) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade500,
          ),
          Text(
            number.toString(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return StreamBuilder(
        stream: Firestore.instance
            .collection('psikologlar')
            .document(userID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          User user = User.fromDocument(snapshot.data);

          return Scaffold(
            appBar: PsiTopBar.withBackButton(width, context),
            bottomNavigationBar: PsiBottomBar.general(context),
            body: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                        child: Container(
                      width: width,
                      height: height / 6,
                      margin: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/profilarka.png'),
                            fit: BoxFit.fill),
                      ),
                    )),
                    Positioned(
                      child: Container(
                        width: width,
                        height: (7 * height / 8) - 150,
                        margin: EdgeInsets.only(top: height / 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: (height / 5) - (width / 5),
                      left: (width / 2) - 55,
                      child: buildProfileImage(picture, 55),
                    ),
                    Container(
                      height: (height / 8) + (width / 5),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: (height / 7) + (width / 5),
                        ),
                        Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              user.profession,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade900),
                            ),
                            Text(
                              user.username,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.blue.shade800),
                            ),
                          ],
                        )),
                        Container(height: width / 30),
                        Container(
                          width: width - (width / 16),
                          height: width / 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 2, 1, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              buildStatColumn(Icons.people,
                                  _countFollowings(user.followers)),
                              Spacer(),
                              buildProfileFollowButton(),
                              Spacer(),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                child: Container(
                                  height: width / 10,
                                  padding: EdgeInsets.only(left: 9, right: 12),
                                  child: Center(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.message,
                                          size: 20,
                                          color: Colors.grey.shade500,
                                        ),
                                        Text(
                                          " Mesaj",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onPressed: () => {},
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Container(height: width / 30),
                        Container(
                          width: width - (width / 16),
                          height: width / 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.shade800,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 2, 1, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: FlatButton(
                            child: Center(
                              child: Text(
                                "Randevu Al",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () => {}, // takvime
                          ),
                        ),
                        Container(height: width / 30),
                        // new Hakkinda(bio: kisi.bio, okul: kisi.okul, oy: kisi.rating),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  int _countFollowings(List followings) {
    int count = 0;

    void countValues(value) {
      if (value) {
        count += 1;
      }
    }

    followings.forEach(countValues);

    return count;
  }

  bool get wantKeepAlive => true;
}

Widget psikologProfil(uid, height, width) {
  String name;
  String username;
  String profession;

  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Container(
                width: width,
                height: height / 6,
                margin: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/profilarka.png'),
                      fit: BoxFit.fill),
                ),
              )),
              Positioned(
                child: Container(
                  width: width,
                  height: 5 * (height / 6),
                  margin: EdgeInsets.only(top: height / 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (height / 8) - (width / 6),
                left: (width / 3),
                child: Center(
                  child: Container(
                    width: width / 3,
                    height: width / 3,

                    // decoration: BoxDecoration(
                    //   color: Colors.grey.shade200,
                    //   image: DecorationImage(
                    //     image: NetworkImage(resim),
                    //     fit: BoxFit.cover,
                    //   ),
                    //   borderRadius: BorderRadius.circular(width/6), //80.0
                    //   border: Border.all(
                    //     color: Colors.grey.shade200,
                    //     width: 8.0,
                    //   ),
                    // ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: (height / 8) + (width / 5),
                  ),
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        profession,
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade900),
                      ),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 15, color: Colors.blue.shade800),
                      ),
                    ],
                  )),
                  Container(height: width / 30),
                  Container(
                    width: width - (width / 16),
                    height: width / 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 2, 1, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          height: width / 10,
                          padding: EdgeInsets.only(right: 15, left: 12),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.people,
                                  size: 20,
                                  color: Colors.grey.shade500,
                                ),
                                Text(
                                  // veriyi çekicez
                                  "1.5M",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            height: width / 10,
                            padding: EdgeInsets.only(right: 12, left: 12),
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.blueAccent,
                                  ),
                                  Text(
                                    "Takip Et",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                        Spacer(),
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            height: width / 10,
                            padding: EdgeInsets.only(left: 9, right: 12),
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.message,
                                    size: 20,
                                    color: Colors.grey.shade500,
                                  ),
                                  Text(
                                    " Mesaj",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onPressed: () => {},
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Container(height: width / 30),
                  Container(
                    width: width - (width / 16),
                    height: width / 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green.shade800,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 2, 1, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: FlatButton(
                      child: Center(
                        child: Text(
                          "Randevu Al",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () => {}, // takvime
                    ),
                  ),
                  Container(height: width / 30),
                  // new Hakkinda(bio: kisi.bio, okul: kisi.okul, oy: kisi.rating),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
