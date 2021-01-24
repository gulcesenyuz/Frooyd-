import 'package:flutter/material.dart';

class BottomBarState extends ChangeNotifier{

  int bottomindex = 0;


  void pageselect(int index){
    bottomindex = index;
    notifyListeners();
  }





}