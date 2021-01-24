import 'package:flutter/material.dart';
import 'package:frooyd/USER/user_profile/profileView.dart';


class Profil extends StatefulWidget {
  final String userProfileID;
  Profil({Key key, this.title, this.userProfileID}) : super(key: key);
  final String title;

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }

  }
