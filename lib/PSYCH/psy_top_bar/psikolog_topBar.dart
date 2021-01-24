import 'package:flutter/material.dart';
import 'package:frooyd/PROVIDER/bottombarstate.dart';
import 'package:frooyd/PSYCH/share_post/addPost.dart';
import 'package:frooyd/widget/frooyd_icons.dart';
import 'package:provider/provider.dart';

class PsiTopBar {

  static withBackButton(num width, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0),
      child: Container(
        width: width,
        height: 70,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.navigate_before,
                      size: 30, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: width/4.5,),
                Padding(
                 padding: const EdgeInsets.only(right: 5), // DEVİCE GENİŞLİĞİNE GÖRE AYARLANCAK
                  child: Image(
                    //  height: 85,
                      image: AssetImage('assets/images/frooydlogo.png')),
                ),
                SizedBox(width: width/4.5,),
                IconButton(
                  icon: Icon(Icons.add,
                      size: 30, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                     MaterialPageRoute(builder: (context) => AddPost()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static general(num width, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0),
      child: Container(
        width: width,
        height: 70,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon:
                      Icon(Frooyd.user_plus, size: 20, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, 'kesfet');
                      } ),
                  Image(
                      alignment: Alignment.center,
                      //    height: 60,

                      image: AssetImage('assets/images/frooydlogo.png')),
                  IconButton(
                      icon: Icon(Icons.plus_one, size: 30, color: Colors.white,),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPost()),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  static main(num width, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0),
      child: Container(
        width: width,
        height: 70,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.navigate_before,
                        size: 30, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: width/4.5,),
                  Image(
                      alignment: Alignment.center,
                      //    height: 60,
                      image: AssetImage('assets/images/frooydlogo.png')),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class PsiBottomBar{

  static general(BuildContext context) {

    final bottombar = Provider.of<BottomBarState>(context);

    return Container(
      height: 43,
      //  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: BottomNavigationBar(
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        currentIndex: bottombar.bottomindex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              // ignore: deprecated_member_use
              title: Text(
                "Ana Sayfa",
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              // ignore: deprecated_member_use
              title: Text(
                "Görüşmelerim",
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              // ignore: deprecated_member_use
              title: Text(
                "Danışman Ara",
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              // ignore: deprecated_member_use
              title: Text(
                "Profilim",
              )),
        ],
        selectedItemColor: Colors.blue,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.popAndPushNamed(context, 'psihomepage');
              break;
            case 1:
                Navigator.popAndPushNamed(context, 'psigorusmeler'); // psikolog randevu olacak girdi
              break;
            case 2:
              Navigator.popAndPushNamed(context, 'ara');
              break;
            case 3:
              Navigator.popAndPushNamed(context, 'psiprofil');
              break;

              break;
          }
        },
      ),
    );
  }
}