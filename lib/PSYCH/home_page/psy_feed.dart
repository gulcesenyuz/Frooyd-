import 'package:flutter/material.dart';
import 'package:frooyd/PSYCH/home_page/psy_feedShow.dart';
import 'package:frooyd/PSYCH/psy_top_bar/psikolog_topBar.dart';


class MainPagePsy extends StatefulWidget {
  MainPagePsy({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPagePsyState createState() => _MainPagePsyState();
}

class _MainPagePsyState extends State<MainPagePsy> with SingleTickerProviderStateMixin {
  TabController _controller;

  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
     appBar: PsiTopBar.general(width, context  ),
     bottomNavigationBar: PsiBottomBar.general(context),
      body: Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 10,
              ),
              Container(
                height: 40,
                width: width - (width / 16),
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
                child: new TabBar(
                  indicatorColor: Colors.blueAccent,
                  indicatorPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  controller: _controller,
                  tabs: [
                    new Tab(
                      child: Text(
                        'Güncel Akış',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    new Tab(
                      child: Text(
                        'Beğendiklerim',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 5),
              new Container(
                height: height - 170,
                //height - 233,
                child: new TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    FeedPsy(),
                    BegendimSayfa(),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}

