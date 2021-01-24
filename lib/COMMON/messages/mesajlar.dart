import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/app_bars/custom_bar.dart';

class Mesaj extends StatefulWidget {
  Mesaj({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MesajState createState() => _MesajState();
}

class _MesajState extends State<Mesaj> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar.withBackButton(width, context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Mesaj Yok',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
