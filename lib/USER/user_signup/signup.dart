import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/app_bars/custom_bar.dart';
import 'package:frooyd/SERVICES/auth.dart';
import 'package:frooyd/widget/Animation/FadeAnimation.dart';
import 'package:frooyd/widget/Animation/loadingAnimation.dart';

class SignPage extends StatefulWidget {
  // SignPage({Key key}) : super(key: key);
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController sifreController = new TextEditingController();
  String error = '';
  bool loading = false;

  final AuthService authService = new AuthService();

  signMeUp() {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      authService.signUpWithEmailAndPassword(
          emailController.text, sifreController.text);
      Navigator.pushNamed(context, 'kayitform');
    }
  }

  String email = '';
  String password = '';
  String passwordRe = '';
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _signbody(width),
      appBar: CustomAppBar.withBackButton(width, context),
    );
  }

  _signbody(num width) {
    return SingleChildScrollView(
      child: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //_logobackground(width),
            _girisbolum(),
          ],
        ),
      ),
    );
  }

  bool passwordCheck(password, passwordRe) {
    RegExp exp =
        new RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$");

    if (password == passwordRe) {
      if (exp.hasMatch(password)) {
        visible = false;
        return false;
      } else {
        visible = true;
        return true;
      }
    } else {
      visible = true;
      return true;
    }
  }

  _girisbolum() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          FadeAnimation(
              1.5,
              Text(
                "Hesap Oluştur",
                style: TextStyle(
                    color: Color.fromRGBO(0, 95, 136, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              )),
          SizedBox(height: 15),
          Container(
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      controller: emailController,
                      validator: (mail) => !mail.contains('@')
                          ? 'Mail hesabınız geçersiz.'
                          : null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "E-posta",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (mail) {
                        setState(() {
                          email = mail;
                        });
                      },
                    ),
                  ),
                  Column(children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        obscureText: true,
                        controller: sifreController,
                        validator: (sifre) => passwordCheck(
                                password, passwordRe)
                            ? 'Hesap oluşturmak için geçerli bir şifre seçiniz.'
                            : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Şifre ",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (sifre) {
                          setState(() {
                            password = sifre;
                            passwordCheck(password, passwordRe);
                          });
                        },
                      ),
                    ),
                    Container(
                      height: visible ? null : 0.0,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]))),
                      child: AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                          height: visible ? null : 0.0,
                          child: Text(
                            'Şifreniz en az 6 karakter, bir sayı ve bir büyük harf içermelidir.',
                            style: TextStyle(
                                color: Color.fromRGBO(0, 136, 255, 1)),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Şifre Tekrar",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (sifreRe) {
                        setState(() {
                          passwordRe = sifreRe;
                          passwordCheck(password, passwordRe);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          loading
              ? Loading()
              : FlatButton(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(0, 95, 136, 1),
                    ),
                    child: Center(
                      child: Text(
                        "Üye Ol",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      print(email); //sil
                      print(password);

                      //signMeUp();
                      dynamic result = await authService
                          .signUpWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Kullanıcı kaydında bir hata oluştu. ';
                          loading = false;
                        });
                      }
                      signMeUp();
                    }
                  }),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              error,
              style: TextStyle(
                  fontSize: 14, color: Color.fromRGBO(0, 136, 255, 1)),
            ),
          )
        ],
      ),
    );
  }
}
