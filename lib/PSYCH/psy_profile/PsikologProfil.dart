import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/profile_picture/profile_picture.dart';
import 'package:frooyd/PSYCH/psy_top_bar/psikolog_topBar.dart';
import 'package:frooyd/PSYCH/psy_profile_settings/edit_profile_page_psy.dart';

class PsikologProfil extends StatefulWidget {
  final String userProfilId;
  PsikologProfil({this.userProfilId});
  @override
  _PsikologProfilState createState() => _PsikologProfilState();
}

class _PsikologProfilState extends State<PsikologProfil> {
  String name = 'name';
  String username = 'username';
  String picture = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  void getProfileData() async {
    try {
      print("test");
      FirebaseUser user = await _auth.currentUser();
      DocumentSnapshot doc = await Firestore.instance
          .collection("psikologlar")
          .document(user.uid)
          .get();
      setState(() {
        name = doc.data["name"];
        username = doc.data["username"];
        picture = doc.data["picUrl"];
      });
    } catch (e) {
      print("eeeeeeeeeeeeee");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PsiTopBar.withBackButton(width, context),
      bottomNavigationBar: PsiBottomBar.general(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                      child: Container(
                    width: width,
                    height: (height / 4),
                    //margin: EdgeInsets.only(top: height / 350),
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
                  SizedBox(
                    height: width / 15,
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
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            username,
                            style: TextStyle(
                                fontSize: 15, color: Colors.blue.shade800),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: width / 15,
                      ),
                      Container(
                        width: (4 * width / 5),
                        height: width / 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Container(
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
                                height: width / 10,
                                width: 1.90 * width / 5,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.people,
                                        color: Colors.grey.shade500,
                                        size: 20,
                                      ),
                                      Text(
                                        "Takip Edilenler",
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
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Container(
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
                                height: width / 10,
                                width: 1.90 * width / 5,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.save,
                                        color: Colors.grey.shade500,
                                        size: 20,
                                      ),
                                      Text(
                                        "Kaydettiklerim",
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
                              onPressed: () =>
                                  Navigator.pushNamed(context, 'kaydettim'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: width / 15,
                      ),
                      Container(
                        width: (4 * width / 5),
                        height: 4 * (width / 6),
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
                        child: Column(
                          children: <Widget>[
                            FlatButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300)),
                                ),
                                height: width / 6,
                                child: Center(
                                  child: Text(
                                    "Profili Düzenle",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfilePagePsy())),
                              },
                            ),
                            FlatButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300)),
                                ),
                                height: width / 6,
                                child: Center(
                                  child: Text(
                                    "Bilgilerim",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () => {},
                            ),
                            FlatButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300)),
                                ),
                                height: width / 6,
                                child: Center(
                                  child: Text(
                                    "Ayarlar",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () => {},
                            ),
                            FlatButton(
                              child: Container(
                                height: width / 6,
                                child: Center(
                                  child: Text(
                                    "Çıkış Yap",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await _auth.signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'signin', (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
