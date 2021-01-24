import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/app_bars/custom_bar.dart';
import 'package:frooyd/COMMON/profile_picture/profile_picture.dart';

class Kesfet extends StatefulWidget {
  Kesfet({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KesfetState createState() => _KesfetState();
}

class _KesfetState extends State<Kesfet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name;
  String username;
  String profession;
  String picture;

  @override
  void initState() {
    //getProfileData();
    _randomList();
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
        profession = doc.data["profession"];
        // picture=doc.data["picUrl"];
        print(picture);
      });
    } catch (e) {
      print("eeeeeeeeeeeeee");
    }
  }

  _randomList() async {
    print('randomList1');
    //get firestore documents from collection
    QuerySnapshot qs =
        await Firestore.instance.collection('psikologlar').getDocuments();
    print('randomList5');
    List<DocumentSnapshot> listedQS = qs.documents; //listed documents
    print(listedQS);
    var random = new Random(); //dart math
//shuffle the array
    for (var i = listedQS.length - 1; i > 0; i--) {
      print('randomList2');

      var n = random.nextInt(i + 1);
      print(n);

      var temp = listedQS[i];
      print(temp);

      listedQS[i] = listedQS[n];
      print(listedQS[i]);

      listedQS[n] = temp;
    }
    print('randomList3');

    DocumentSnapshot randomDocument =
        listedQS[0]; //the random data from firebase
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      //  appBar: CustomAppBar.withBackButton(width, context),
      bottomNavigationBar: BottomBarCustom.general(context),
      body: StreamBuilder(
          stream: _randomList(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  height: height / 6,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Positioned(
                        // top: (height / 8) - (width / 6),
                        // left: (width / 3),
                        child: buildProfileImage(snapshot.data['picture'], 55),
                      ),
                      FlatButton(
                          onPressed: () {
                            //psikolog profil gidecek
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    //profile_picture(picture),
                                    Container(
                                      width: 15,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          snapshot.data['name'],
                                          style: new TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data['profession'],
                                          style: new TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data['username'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      //  Container(width: 90,),
                      //followButtom(bisi),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}

/*/*
Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(height: 20,),
                      Container(
                        child: FlatButton(
                            onPressed: (){},
                            child: Container(
                          child: Column(
                          children: <Widget>[
                                 Container(
                                   child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(kullanici.image),
                                      radius: 25,
                          ),
                        ),
                          Text(
                              kullanici.isim,
                              style: new TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              kullanici.alan, style: new TextStyle(
                                fontSize: 9,
                              ),),
                            Text(
                              kullanici.kuladi, style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue.shade800,
                            ),),
                          ],
                        ),)),
                      ),
                      Container(height: 10,),

                      Container(
                       width: 100,
                       height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blueAccent,
                        ),
                        child: FlatButton(
                            onPressed: (){},
                            child: Container(child:
                            Text("Takip Et",
                                style: TextStyle(color: Colors.white,
                                  fontWeight:FontWeight.bold, fontSize:10,)),))),
                    ],
                ),
              );
 */


  title: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //resim
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(kullanici.image),
                          radius: 25,
                        ),
                      ),
                      //resim bitis

                      Container(
                        width: 15,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            kullanici.isim,
                            style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(kullanici.alan, style: new TextStyle(
                              fontSize: 13,
                            
                            ),),
                          Text(kullanici.kuladi, style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade800,

                          ),),
                        ],
                      ),

                      Spacer(),

                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconTheme(
                                data: IconThemeData(
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                child: Icon(Icons.star),
                              ),
                              Text(
                                kullanici.rating,
                                textAlign: TextAlign.center,
                                 style: TextStyle(fontSize: 15,)
                              ),
                            ],
                          ),
                          //  Text("Premium", style: TextStyle(fontSize: 13.0), ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),



*/

/* onPressed: () {
            sayfa.pageselectpsi(14, index);
            dahafazla.kapat();
          }

          */
