import 'package:flutter/material.dart';
import 'package:frooyd/PROVIDER/bottombarstate.dart';
import 'package:frooyd/widget/frooyd_icons.dart';
import 'package:provider/provider.dart';

class CustomAppBar {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.navigate_before,
                      size: 30, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Image(
                    //  height: 85,
                    image: AssetImage('assets/images/frooydlogo.png')),
                IconButton(
                  icon: Icon(Icons.navigate_before,
                      size: 30, color: Colors.transparent),
                  onPressed: () {},
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
                      icon: Icon(Frooyd.comment, size: 20, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, 'mesaj');
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBarCustom {
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
              icon: Icon(Icons.today),
              // ignore: deprecated_member_use
              title: Text(
                "Randevularım",
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
              Navigator.popAndPushNamed(context, 'homepage');
              break;
            case 1:
              Navigator.popAndPushNamed(context, 'randevu');
              break;
            case 2:
              Navigator.popAndPushNamed(context, 'ara');
              break;
            case 3:
              Navigator.popAndPushNamed(context, 'profil');
              break;
          }
        },
      ),
    );
  }
}

