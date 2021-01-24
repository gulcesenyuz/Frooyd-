import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/SPLASH_PAGE/splashPage.dart';
import 'package:frooyd/COMMON/messages/mesajlar.dart';
import 'package:frooyd/PSYCH/home_page/psy_feed.dart';
import 'package:frooyd/PSYCH/psy_login/PsikologGirisSayfa.dart';
import 'package:frooyd/PSYCH/psy_profile/PsikologProfil.dart';
import 'package:frooyd/PSYCH/psy_signup/PsikologBilgiKayit.dart';
import 'package:frooyd/PSYCH/psy_signup/psikologKay%C4%B1t.dart';
import 'package:frooyd/USER/home_page/homePage.dart';
import 'package:frooyd/USER/home_page/kesfet.dart';
import 'package:frooyd/USER/user_login/signin.dart';
import 'package:frooyd/USER/user_signup/kay%C4%B1tForm.dart';
import 'package:frooyd/USER/user_signup/signup.dart';

// ignore: missing_return
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => SplashPage());

    case 'signin':
      return PageRouteBuilder(pageBuilder: (context, a1, a2) => LoginPage());
    case 'signup':
      return MaterialPageRoute(builder: (context) => SignPage());
    case 'signin-p':
      return MaterialPageRoute(builder: (context) => SignPage());
    case 'signup-p':
      return MaterialPageRoute(builder: (context) => PsikologKayit());
    case 'homepage':
      return PageRouteBuilder(
          pageBuilder: (context, a1, a2) => HomePage(
                pageindex: 0,
              ));
    case 'randevu':
      return PageRouteBuilder(
          pageBuilder: (context, a1, a2) => HomePage(
                pageindex: 1,
              ));
    case 'ara':
      return PageRouteBuilder(
          pageBuilder: (context, a1, a2) => HomePage(
                pageindex: 2,
              ));
    case 'profil':
      return PageRouteBuilder(
          pageBuilder: (context, a1, a2) => HomePage(
                pageindex: 3,
              ));
    case 'mesaj':
      return PageRouteBuilder(pageBuilder: (context, a1, a2) => Mesaj());
    case 'kesfet':
      return PageRouteBuilder(pageBuilder: (context, a1, a2) => Kesfet());
    // case 'kaydettim':
    //    return PageRouteBuilder(pageBuilder: (context, a1, a2) => Kaydettiklerim());
    case 'psiprofil':
      return MaterialPageRoute(builder: (context) => PsikologProfil());
    case 'psihomepage':
      return MaterialPageRoute(builder: (context) => MainPagePsy());
    // case'psigorusmeler':
    //   return MaterialPageRoute(builder: (context) => PsiRandevuGorusme());
    case 'kayitform':
      return MaterialPageRoute(builder: (context) => KayitForm());
    case 'psikayitform':
      return MaterialPageRoute(builder: (context) => PsikologBilgiKayit());
    case 'psikologGiris':
      return MaterialPageRoute(builder: (context) => PsikologGirisSayfa());
  }
}

// PageRouteBuilder(pageBuilder: (_, a1, a2) => SignPage());  animasyonsuz için
