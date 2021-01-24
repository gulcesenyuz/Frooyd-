import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frooyd/PSYCH/share_post/image_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPsy extends StatefulWidget {
  _FeedPsy createState() => _FeedPsy();
}

class _FeedPsy extends State<FeedPsy>
    with AutomaticKeepAliveClientMixin<FeedPsy> {
  List<ImagePost> feedData;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userID;
  String name;
  String username;
  String picture;

  void getProfileData() async {
    try {
      print("test");
      FirebaseUser user = await _auth.currentUser();
      userID = user.uid;
      DocumentSnapshot doc =
          await Firestore.instance.collection("users").document(user.uid).get();
      setState(() {
        name = doc.data["name"];
        username = doc.data["username"];
        picture = doc.data["picUrl"];
      });
    } catch (e) {
      print("error2");
    }
  }

  @override
  void initState() {
    super.initState();
    this._loadFeed();
  }

  buildFeed() {
    if (feedData != null) {
      return ListView(
        children: feedData,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  Future<Null> _refresh() async {
    await _getFeed();
    setState(() {});
    return;
  }

  _loadFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("feed");

    if (json != null) {
      List<Map<String, dynamic>> data =
          jsonDecode(json).cast<Map<String, dynamic>>();
      List<ImagePost> listOfPosts = _generateFeed(data);
      setState(() {
        feedData = listOfPosts;
      });
    } else {
      _getFeed();
    }
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];

    for (var postData in feedData) {
      listOfPosts.add(ImagePost.fromJSON(postData));
    }

    return listOfPosts;
  }

  _getFeed() async {
    print("Staring getFeed");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url =
        'https://us-central1-mp-rps.cloudfunctions.net/getFeed?uid=' + userID;
    var httpClient = HttpClient();
    List<ImagePost> listOfPosts;
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        prefs.setString("feed", json);
        List<Map<String, dynamic>> data =
            jsonDecode(json).cast<Map<String, dynamic>>();
        listOfPosts = _generateFeed(data);
        result = "Success in http request for feed";
      } else {
        result =
            'Error getting a feed: Http status ${response.statusCode} | userId $userID';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    print(result);

    setState(() {
      feedData = listOfPosts;
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again
    return Container(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: buildFeed(),
      ),
    );
  }

//********************************************************
// @override
// Widget build(BuildContext context) {
//   final width = MediaQuery.of(context).size.width;
//   //final dahafazla = Provider.of<Dahafazla>(context);
//   return CustomScrollView(
//     slivers: <Widget>[
//       // SliverList(
//       //   delegate: SliverChildListDelegate(
//       //     List.generate(
//       //       tumGonderi.length,
//       //       (int index) {
//       //         int kulindex = int.parse(tumGonderi[index].paylasan.kulid);
//       //         return Column(
//       //           children: <Widget>[
//       //             Container(height: 10),
//       //             Container(
//       //               width: width - (width / 16),
//       //               decoration: BoxDecoration(
//       //                   borderRadius: BorderRadius.circular(10),
//       //                   color: Colors.white,
//       //                   boxShadow: [
//       //                     BoxShadow(
//       //                       color: Color.fromRGBO(0, 2, 1, .3),
//       //                       blurRadius: 20,
//       //                       offset: Offset(0, 10),
//       //                     )
//       //                   ]),
//       //               child: Column(
//       //                 children: <Widget>[
//       //                   Container(height: 5),
//       //                   FlatButton(
//       //                     padding: EdgeInsets.only(left: 5),
//       //                     onPressed: () {
//       //                       Navigator.push(context, PageRouteBuilder(
//       //                           pageBuilder: (context, a1, a2) {
//       //                         return Psiprofil(
//       //                           kulindex: kulindex,
//       //                         );
//       //                       }));
//       //                     },
//       //                     child: ListTile(
//       //                       leading: CircleAvatar(
//       //                         radius: 20,
//       //                         backgroundImage: NetworkImage(
//       //                           tumGonderi[index].paylasan.image,
//       //                         ),
//       //                       ),
//       //                       title: Column(
//       //                         crossAxisAlignment: CrossAxisAlignment.start,
//       //                         children: <Widget>[
//       //                           Text(
//       //                             tumGonderi[index].paylasan.isim,
//       //                             style: TextStyle(
//       //                                 fontSize: 15,
//       //                                 fontWeight: FontWeight.bold),
//       //                           ),
//       //                           Text(
//       //                             tumGonderi[index].paylasan.kuladi,
//       //                             style: TextStyle(
//       //                                 fontSize: 12,
//       //                                 fontWeight: FontWeight.bold,
//       //                                 color: Colors.grey),
//       //                           ),
//       //                         ],
//       //                       ),
//       //                     ),
//       //                   ),
//       //                   Container(
//       //                     padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
//       //                     child: Image.asset(
//       //                       "assets/images/${tumGonderi[index].gonderiresim}",
//       //                       fit: BoxFit.fill,
//       //                     ),
//       //                   ),
//       //                   Container(
//       //                     padding: EdgeInsets.only(top:5),
//       //                     child: new DescriptionTextWidget(
//       //                       text: tumGonderi[index].gonderiyazi,
//       //                       tarih: tumGonderi[index].tarih,
//       //
//       //                     ),
//       //                   ),
//       //                   Container(
//       //                     width: width - (width / 16),
//       //                     child: Row(
//       //                       children: <Widget>[
//       //                         Container(
//       //                           width: (width - (width / 16)) / 4,
//       //                           child: FavoriteWidget(
//       //                             index: index,
//       //                             context: context,
//       //                           ),
//       //                         ),
//       //                         Container(
//       //                           width: (width - (width / 16)) / 4,
//       //                           child: FlatButton(
//       //                             child: Container(
//       //                               height: width / 8,
//       //                               child: Center(
//       //                                 child: Icon(
//       //                                   Icons.comment,
//       //                                   color: Colors.grey,
//       //                                 ),
//       //                               ),
//       //                             ),
//       //                               onPressed: () {
//       //                                 Navigator.push(
//       //                                   context,
//       //                                   MaterialPageRoute(builder: (context) => Comment()),
//       //                                 );
//       //                               }
//       //                           ),
//       //                         ),
//       //                         Container(
//       //                           width: (width - (width / 16)) / 4,
//       //                           child: KaydettusWidget(
//       //                             index: index,
//       //                             context: context,
//       //                           ),
//       //                         ),
//       //                         Container(
//       //                           width: (width - (width / 16)) / 4,
//       //                           child: FlatButton(
//       //                             child: Container(
//       //                               height: width / 8,
//       //                               child: Center(
//       //                                 child: Icon(
//       //                                   Icons.send,
//       //                                   color: Colors.grey,
//       //                                 ),
//       //                               ),
//       //                             ),
//       //                             onPressed: () {},
//       //                           ),
//       //                         ),
//       //                       ],
//       //                     ),
//       //                   ),
//       //                 ],
//       //               ),
//       //             ),
//       //             Container(height: 7.5),
//       //           ],
//       //         );
//       //       },
//       //     ),
//       //   ),
//       // ),
//     ],
//   );
// }
//********************************************************
}

class BegendimSayfa extends StatefulWidget {
  BegendimSayfa();

  @override
  _BegendimSayfaState createState() => new _BegendimSayfaState();
}

class _BegendimSayfaState extends State<BegendimSayfa> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Beğendiğin Gönderi Yok',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
        ],
      ),
    );

    // return CustomScrollView(
    //   slivers: <Widget>[
    //     SliverList(
    //       delegate: SliverChildListDelegate(
    //         List.generate(
    //           begendim.begendiklerimindex.length,
    //           (int olustur) {
    //             int index = begendim.begendiklerimindex[olustur];
    //             int kulindex = int.parse(tumGonderi[index].paylasan.kulid);
    //             return Column(
    //               children: <Widget>[
    //                 Container(height: 5),
    //                 Container(
    //                   width: width - (width / 16),
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10),
    //                       color: Colors.white,
    //                       boxShadow: [
    //                         BoxShadow(
    //                           color: Color.fromRGBO(0, 2, 1, .3),
    //                           blurRadius: 20,
    //                           offset: Offset(0, 10),
    //                         )
    //                       ]),
    //                   child: Column(
    //                     children: <Widget>[
    //                       Container(height: 5),
    //                       FlatButton(
    //                         padding: EdgeInsets.only(left: 5),
    //                         onPressed: () {
    //                           Navigator.push(context, PageRouteBuilder(
    //                               pageBuilder: (context, a1, a2) {
    //                             return Psiprofil(
    //                               kulindex: kulindex,
    //                             );
    //                           }));
    //                         },
    //                         child: ListTile(
    //                           leading: CircleAvatar(
    //                             radius: 20,
    //                             backgroundImage: NetworkImage(
    //                               tumGonderi[index].paylasan.image,
    //                             ),
    //                           ),
    //                           title: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: <Widget>[
    //                               Text(
    //                                 tumGonderi[index].paylasan.isim,
    //                                 style: TextStyle(
    //                                     fontSize: 15,
    //                                     fontWeight: FontWeight.bold),
    //                               ),
    //                               Text(
    //                                 tumGonderi[index].paylasan.kuladi,
    //                                 style: TextStyle(
    //                                     fontSize: 12,
    //                                     fontWeight: FontWeight.bold,
    //                                     color: Colors.grey),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //                         child: Image.asset(
    //                           "assets/images/${tumGonderi[index].gonderiresim}",
    //                           fit: BoxFit.fill,
    //                         ),
    //                       ),
    //                       Container(
    //                         child: new DescriptionTextWidget(
    //                           text: tumGonderi[index].gonderiyazi,
    //                           tarih: tumGonderi[index].tarih,
    //                         ),
    //                       ),
    //                       Container(
    //                         width: width - (width / 16),
    //                         child: Row(
    //                           children: <Widget>[
    //                             Container(
    //                               width: (width - (width / 16)) / 4,
    //                               child: FavoritebegendimWidget(
    //                                 index: index,
    //                                 context: context,
    //                               ),
    //                             ),
    //                             Container(
    //                               width: (width - (width / 16)) / 4,
    //                               child: FlatButton(
    //                                 child: Container(
    //                                   height: width / 8,
    //                                   child: Center(
    //                                     child: Icon(
    //                                       Icons.comment,
    //                                       color: Colors.grey,
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 onPressed: () {
    //
    //                                   Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(builder: (context) => Comment()),
    //                                   );
    //
    //                                 },
    //                               ),
    //                             ),
    //                             Container(
    //                               width: (width - (width / 16)) / 4,
    //                               child: KaydettusWidget(
    //                                 index: index,
    //                                 context: context,
    //                               ),
    //                             ),
    //                             Container(
    //                               width: (width - (width / 16)) / 4,
    //                               child: FlatButton(
    //                                 child: Container(
    //                                   height: width / 8,
    //                                   child: Center(
    //                                     child: Icon(
    //                                       Icons.send,
    //                                       color: Colors.grey,
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 onPressed: () {},
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Container(height: 7.5),
    //               ],
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}

class KaydettimSayfa extends StatefulWidget {
  KaydettimSayfa();

  @override
  _KaydettimSayfaState createState() => new _KaydettimSayfaState();
}

class _KaydettimSayfaState extends State<KaydettimSayfa> {
  @override
  Widget build(BuildContext context) {
    //final dahafazla = Provider.of<Dahafazla>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Kaydettiğin Gönderi Yok',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
        ],
      ),
    );
  }
// return CustomScrollView(
//   slivers: <Widget>[
//     SliverList(
//       delegate: SliverChildListDelegate(
//         List.generate(
//           kaydettim.kaydettiklerimindex.length,
//           (int olustur) {
//             int index = kaydettim.kaydettiklerimindex[olustur];
//             int kulindex = int.parse(tumGonderi[index].paylasan.kulid);
//
//             return Column(
//               children: <Widget>[
//                 Container(height: 5),
//                 Container(
//                   width: width - (width / 16),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color.fromRGBO(0, 2, 1, .3),
//                           blurRadius: 20,
//                           offset: Offset(0, 10),
//                         )
//                       ]),
//                   child: Column(
//                     children: <Widget>[
//                       Container(height: 5),
//                       FlatButton(
//                         padding: EdgeInsets.only(left: 5),
//                         onPressed: () {
//                           Navigator.push(context, PageRouteBuilder(
//                               pageBuilder: (context, a1, a2) {
//                             return Psiprofil(
//                               kulindex: kulindex,
//                             );
//                           }));
//                         },
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             radius: 20,
//                             backgroundImage: NetworkImage(
//                               tumGonderi[index].paylasan.image,
//                             ),
//                           ),
//                           title: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 tumGonderi[index].paylasan.isim,
//                                 style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 tumGonderi[index].paylasan.kuladi,
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                         child: Image.asset(
//                           "assets/images/${tumGonderi[index].gonderiresim}",
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       Container(
//                         child: new DescriptionTextWidget(
//                           text: tumGonderi[index].gonderiyazi,
//                           tarih: tumGonderi[index].tarih,
//                         ),
//                       ),
//                       Container(
//                         width: width - (width / 16),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               width: (width - (width / 16)) / 4,
//                               child: FavoriteWidget(
//                                 index: index,
//                                 context: context,
//                               ),
//                             ),
//                             Container(
//                               width: (width - (width / 16)) / 4,
//                               child: FlatButton(
//                                 child: Container(
//                                   height: width / 8,
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.comment,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () {},
//                               ),
//                             ),
//                             Container(
//                               width: (width - (width / 16)) / 4,
//                               child: KaydettimWidget(
//                                 index: index,
//                                 context: context,
//                               ),
//                             ),
//                             Container(
//                               width: (width - (width / 16)) / 4,
//                               child: FlatButton(
//                                 child: Container(
//                                   height: width / 8,
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.send,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () {},
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(height: 7.5),
//               ],
//             );
//           },
//         ),
//       ),
//     ),
//   ],
// );

}
