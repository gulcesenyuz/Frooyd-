import 'dart:async';
import 'package:flutter/material.dart';


class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);


  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{

 
 bool isSigned = false;

   void initstate(){
    super.initState();
 }
 void dispose(){
   super.dispose();
 }
 
 
  @override
  Widget build(BuildContext context) {

    Timer(Duration(seconds: 3,),(){
      if (isSigned == false) {
      Navigator.pushReplacementNamed(context, "signin");
    }
    else{
      Navigator.pushReplacementNamed(context, "signin");
    }
    });

    return Scaffold(
      body: Center(
        child: RotateImage(),
      ),
      backgroundColor: Colors.blueAccent,
      
      );
  }
}


class RotateImage extends StatefulWidget {
  @override
  RotateImageState createState() => new RotateImageState();
}

class RotateImageState extends State<RotateImage>
    with SingleTickerProviderStateMixin {
    AnimationController animationController;

void initState() {
    super.initState();
 
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1500),
    );
 
    animationController.repeat();
  }
  void dispose(){
    animationController.dispose();
    super.dispose();
  }
  
stopRotation(){

    animationController.stop();
  }

  startRotation(){
    
    animationController.repeat();
  }

  Widget build(BuildContext context){
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
          builder: (BuildContext context, Widget _widget) {
          return Transform.rotate(
            angle: animationController.value * 6.3,
            child: _widget,
          );
        },
          animation: animationController,
          child: Container(
            width: width/4,
                      decoration: BoxDecoration(
                      
                        image: DecorationImage(
                          image: AssetImage('assets/images/frooydgozluk.png'),
                          alignment: Alignment.center,
                         // fit: BoxFit.fill
                        
                        )
                      ),
                    ),
    );

  }
 
}



class Yonlendir extends StatefulWidget{
  Yonlendir({Key key}) : super(key: key);

 
  @override
  _YonlendirState createState() => new _YonlendirState();

}
class _YonlendirState extends State<SplashPage> {
 bool isSigned = false;


@override
  void initState() {
    
    super.initState();
  }

  Widget build(BuildContext context){
    return null;
  }


}