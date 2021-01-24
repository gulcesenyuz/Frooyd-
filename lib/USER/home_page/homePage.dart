import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/app_bars/custom_bar.dart';
import 'package:frooyd/COMMON/randevu/randevu.dart';
import 'package:frooyd/COMMON/search/search.dart';
import 'package:frooyd/PROVIDER/bottombarstate.dart';
import 'package:frooyd/USER/home_page/user_feed.dart';
import 'package:frooyd/USER/user_profile/profil.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
    HomePage({Key key, @required this.pageindex, this.uid}) : super(key: key);
  final int pageindex;
  final String uid;
 
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  
  PageController pageController;
  int getPageIndex;

  void initState(){
    super.initState();
    this.getPageIndex = widget.pageindex;
    pageController = PageController(initialPage: widget.pageindex);
  }

  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  whenPageChanges(int pageIndex){
    setState(() {
       this.getPageIndex = pageIndex;
       
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bottombar = Provider.of<BottomBarState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.general(width, context),
      body: PageView(
        children: <Widget>[
          MainPage(),
          Randevu(),
          Search(),
          Profil(),

        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ), 
      
      bottomNavigationBar: Container(
              height: 43,
              child: BottomNavigationBar(
          iconSize: 30,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedFontSize: 0,
          selectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                 // ignore: deprecated_member_use
                 title: Text(
                  "Ana Sayfa",
                )
               ),
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
          currentIndex: getPageIndex,
          selectedItemColor: Colors.blue,
          onTap: (int pageIndex) {
            bottombar.pageselect(pageIndex);
            pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 5), curve: Curves.bounceIn);
          }
          //onTapChangePage,
        ),
      ),
    );
  }
}

