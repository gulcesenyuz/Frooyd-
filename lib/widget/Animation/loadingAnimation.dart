import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color.fromRGBO(0, 95, 136, 1),
      ),
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.white,
          size:20,
              duration: const Duration(milliseconds: 500),

        ),
      ),
    );
  }
}
