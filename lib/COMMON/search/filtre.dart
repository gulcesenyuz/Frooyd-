import 'package:flutter/material.dart';


class Filtre extends StatefulWidget {
 Filtre({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FiltreState createState() => _FiltreState();
}

class _FiltreState extends State<Filtre> {


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Filtre Yok',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
            
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}