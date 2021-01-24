import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frooyd/COMMON/profile_picture/profile_picture.dart';
import 'package:frooyd/COMMON/search/psyprofile_each.dart';
import 'package:frooyd/COMMON/search/search_service.dart';

class Search extends StatefulWidget {
  Search({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResultSet = [];
  var tempSearchStore = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userID;

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() async {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          print(queryResultSet);
        }
        print('44444444');
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].starsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
          print('!!!!!!!!');
          print(tempSearchStore);
        }
      });
    }
  }

  filter(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.15,
      child: new Container(
        height: 50,
        color: Colors.white,
        child: ListTile(
          leading: Container(
            margin: EdgeInsets.only(top: width / 50),
            child: Icon(
              Icons.people_alt_outlined,
              color: Colors.grey.shade500,
            ),
          ),
          title: Container(
            margin: EdgeInsets.only(left: width / 1.4),
            child: Icon(
              Icons.navigate_next,
              color: Colors.grey.shade500,
              size: 30,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        new IconSlideAction(
          caption: ' ${queryResultSet.length} Kişi',
          color: Colors.indigo,
          icon: Icons.person_pin_circle_outlined,
          onTap: () {},
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Filtrele',
          color: Colors.black45,
          icon: Icons.filter_alt_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  String picture;
  String username;
  String currentID;

  @override
  void initState() {
    getProfileData();

    super.initState();
  }

  void getProfileData() async {
    try {
      print("getProfileData");
      FirebaseUser user = await _auth.currentUser();
      currentID = user.uid;
      DocumentSnapshot doc =
          await Firestore.instance.collection("users").document(user.uid).get();
      setState(() {
        currentID = user.uid;
        picture = doc.data["picUrl"];
        username = doc.data["username"];
        print(currentID);
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      });
    } catch (e) {
      print("eeeeeeeeeeeeee");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return new Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: width / 80,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade200,
                  ),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: TextField(
                    onChanged: (val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 25),
                        hintText: "Danışman Ara..",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                SizedBox(
                  height: width / 80,
                ),
                filter(context),
                SizedBox(
                  height: width / 80,
                ),
                Container(
                  color: Colors.grey.shade200,
                  height: height,
                  child: GridView.count(
                      padding: EdgeInsets.all(2),
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      primary: true,
                      shrinkWrap: true,
                      children: queryResultSet.map((element) {
                        return buildResultCard(element, height, width, context);
                      }).toList()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultCard(data, height, width, context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: GestureDetector(
        onTap: () {
          print(data["userUid"]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PsikologProfil(data["userUid"])));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height / 25),
          child: Column(
            children: [
              Container(
                child: buildProfileImage(data['picUrl'], 35),
              ),
              Text(
                data['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data['profession'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                data['username'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//********************************* */
