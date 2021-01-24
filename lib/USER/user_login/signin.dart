import 'package:flutter/material.dart';
import 'package:frooyd/PSYCH/psy_login/PsikologGirisSayfa.dart';
import 'package:frooyd/services/auth.dart';
import 'package:frooyd/widget/Animation/FadeAnimation.dart';
import 'package:frooyd/widget/Animation/loadingAnimation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String email = ' ';
  String password = ' ';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _loginbody(width, height, context),
    );
  }

  _loginbody(num width, num height, BuildContext context) {
    return SingleChildScrollView(
      child: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _logobackground(width, height),
            _girisbolum(context),
          ],
        ),
      ),
    );
  }

  _logobackground(num width, num height) {
    return Container(
      height: height / 3,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -15,
            right: -100,
            height: height / 3,
            width: width,
            child: FadeAnimation(
                1,
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    // fit: BoxFit.fill
                  )),
                )),
          ),
          Positioned(
            height: height / 3,
            width: width,
            child: FadeAnimation(
                1.3,
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background-2.png'),
                          fit: BoxFit.fill)),
                )),
          ),
          Positioned(
            top: 50,
            height: height / 8,
            width: width,
            child: FadeAnimation(
                1.3,
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/frooydlogo.png'),
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitHeight,
                  )),
                )),
          ),
        ],
      ),
    );
  }

  _girisbolum(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeAnimation(
              1.5,
              Text(
                "Giriş Yap",
                style: TextStyle(
                    color: Color.fromRGBO(0, 95, 136, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              )),
          SizedBox(
            height: 30,
          ),
          FadeAnimation(
            1.7,
            Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 95, 136, .3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      )
                    ]),
                child: Column(
                  children: <Widget>[
                    emailkutucuk(),
                    sifrekutucuk(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              error,
              style: TextStyle(
                  fontSize: 14, color: Color.fromRGBO(0, 136, 255, 1)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FadeAnimation(2, hesapolusturtus()),
          SizedBox(
            height: 30,
          ),
          loading ? Loading() : FadeAnimation(1.9, girisyaptus()),
          SizedBox(
            height: 10,
          ),
          loading ? Loading() : FadeAnimation(1.9, psikologGiris()),
          SizedBox(
            height: 30,
          ),
          FadeAnimation(1.7, sifremiunuttumtus()),
        ],
      ),
    );
  }

  emailkutucuk() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "E-Posta Adresi",
            hintStyle: TextStyle(color: Colors.grey)),
        validator: (val) =>
            val.isEmpty ? 'Lütfen E-Posta Adresinizi giriniz' : null,
        //  onSaved: (value) => email = value.trim(),
        onChanged: (val) {
          setState(() {
            email = val;
          });
        },
      ),
    );
  }

  sifrekutucuk() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        validator: (val) => val.isEmpty ? 'Lütfen şifrenizi giriniz' : null,
        //onSaved: (value) => password = value.trim(),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Şifre",
            hintStyle: TextStyle(color: Colors.grey)),
        onChanged: (val) {
          setState(() {
            password = val;
          });
        },
      ),
    );
  }

  sifremiunuttumtus() {
    return Container(
      child: Center(
          child: Text(
        "Şifremi Unuttum",
        style: TextStyle(color: Color.fromRGBO(0, 95, 136, .6)),
      )),
    );
  }

  girisyaptus() {
    return FlatButton(
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color.fromRGBO(0, 95, 136, 1),
          ),
          child: Center(
            child: Text(
              "Giriş Yap",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        onPressed: () async {
          try {
            if (_formKey.currentState.validate()) {
              setState(() {
                loading = true;
              });
              dynamic result =
                  await _auth.signInWithEmailAndPassword(email, password);
              if (result == null) {
                setState(() {
                  error = 'Kullanıcı girişinde bir hata oluştu. ';
                  loading = false;
                });
              } else {
                Navigator.pushNamed(context, 'homepage');
              }
            }
          } catch (e) {
            print(e);
          }
        });
  }

  hesapolusturtus() {
    return FlatButton(
      child: Center(
          child: Text(
        "Hesap Oluştur",
        style: TextStyle(
            color: Color.fromRGBO(0, 95, 136, .6),
            fontSize: 16,
            fontWeight: FontWeight.w700),
      )),
      onPressed: () => Navigator.pushNamed(context, "signup"),
    );
  }

  psikologGiris() {
    return FlatButton(
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color.fromRGBO(0, 95, 136, 1),
          ),
          child: Center(
            child: Text(
              "Psikolog olarak Giriş Yap",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PsikologGirisSayfa()),
          );
        });
  }
}
