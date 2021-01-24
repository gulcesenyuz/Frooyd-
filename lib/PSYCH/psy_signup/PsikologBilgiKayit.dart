import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frooyd/COMMON/profile_picture/profile_picture.dart';
import 'package:frooyd/SERVICES/auth.dart';
import 'package:frooyd/SERVICES/database.dart';
import 'package:frooyd/widget/Animation/FadeAnimation.dart';
import 'package:frooyd/widget/Animation/loadingAnimation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PsikologBilgiKayit extends StatefulWidget {
  @override
  _PsikologBilgiKayitState createState() => _PsikologBilgiKayitState();
}

class _PsikologBilgiKayitState extends State<PsikologBilgiKayit> {
  final AuthService authService = new AuthService();
  final Database db = Database();
  bool loading = false;
  bool flag1 = false;
  String error = '';
  File _imageFile;
  String imagepath;
  File imageFile;
  String _currentSelectedValue;

  var _gender = ["Kadın", "Erkek", "Diğer"];

  Future imgFromCamera() async {
    PickedFile imageFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    _cropImage(imageFile.path);
  }

  Future imgFromGallery() async {
    PickedFile imageFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    _cropImage(imageFile.path);
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _imageFile = croppedImage;
      setState(() {});
    }
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController adSoyadController = new TextEditingController();
  TextEditingController kullaniciadiController = new TextEditingController();
  TextEditingController telnoController = new TextEditingController();
  TextEditingController professionController = new TextEditingController();
  TextEditingController cinsiyetController = new TextEditingController();
  TextEditingController universityController = new TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  String name = '';
  String gSM = '';
  String username = '';
  String birthDate = '';
  String profession = '';
  String picUrl = '';
  String searchIndex = '';
  String gender = '';
  String age = '';
  String userUid = '';
  String university = '';
  String cV = '';

  uploadPsiData() {
    Map<String, dynamic> psiInfoMap = {
      "name": adSoyadController.text,
      "username": kullaniciadiController.text,
      "GSM": telnoController.text,
      "birthDate": birthDateController.text,
      "profession": professionController.text,
      'picUrl': '',
      ' searchKey': kullaniciadiController.text.substring(0, 1),
      // 'searchIndex': indexList,
      'gender': cinsiyetController.text,
      'userUid': '',
      'university': universityController.text,
      'CV': '',
      "followers": [],
      "following": [],
    };
    print('deneme3');
    db.uploadPsiInfo(psiInfoMap);
    print('deneme4');
  }

  // FilePickerResult result;
  FilePickerResult _path;
  File _pickedFile;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openFileExplorer() async {
    try {
      _path = await FilePicker.platform.pickFiles(
          type: FileType.media, allowedExtensions: ['jpg', 'pdf', 'doc']);
      if (_path != null) {
        setState(() {
          _pickedFile = File(_path.files.single.path);
        });
        PlatformFile myfile = _path.files.first;
        print(myfile.name);
        print(myfile.bytes);
        print(myfile.size);
        print(myfile.extension);
        print(myfile.path);
      }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: _form(width, height),
      //appBar: CustomAppBar.withBackButton(width, context),
    );
  }

  _form(num width, num height) {
    return Stack(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _background(width, height),
        _kayitForm(width, height),
      ],
    );
  }

  _background(num width, num height) {
    return Container(
      height: height / 3,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/newback.png'),
                      fit: BoxFit.fill)),
            ),
          ),
          Positioned(
            top: 50,
            height: height / 8,
            width: width,
            child: Container(
              child: FadeAnimation(
                  1.3,
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/frooydgozluk.png'),
                      alignment: Alignment.bottomCenter,
                      fit: BoxFit.fitHeight,
                    )),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _kayitForm(num width, num height) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: width / 3),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: height / 100, left: (width - 100) / 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 95, 136, .3),
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  )
                ]),
            child: GestureDetector(
              onTap: () {
                showPicker(context);
              },
              child: profilePicture(_imageFile, 55.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height / 6),
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      controller: adSoyadController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Ad-Soyad",
                          hintStyle: TextStyle(color: Colors.grey)),
                      validator: (name) => name.isEmpty
                          ? 'Lütfen Adınızı ve Soyadınızı giriniz'
                          : null,
                      onChanged: (name) {
                        setState(() => name = name);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      controller: kullaniciadiController,
                      validator: (userName) => userName.isEmpty
                          ? 'Lütfen bir kullanıcı adı oluşturun.'
                          : null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Kullanıcı Adı",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (userName) {
                        setState(() => username = userName);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]{0,11}$')),
                      ],
                      controller: telnoController,
                      validator: (telNo) =>
                          telNo.isEmpty ? 'GSM numaranızı girin.' : null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tel. no",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (telNo) {
                        setState(() => gSM = telNo);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: birthDateController,
                      validator: (yil) => yil.isEmpty
                          ? 'Lütfen bir kullanıcı adı oluşturun.'
                          : null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Doğum tarihiniz",
                          hintStyle: TextStyle(color: Colors.grey)),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        DateFormatter(),
                      ],
                      onChanged: (yil) {
                        setState(() => birthDate = yil);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return Container(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black38),
                                labelText: 'Cinsiyet ',
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            value: _currentSelectedValue,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _currentSelectedValue = newValue;
                                state.didChange(newValue);
                                newValue = cinsiyetController.text;
                              });
                            },
                            items: _gender.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  // style: TextStyle(color: Colors.black38),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      controller: professionController,
                      validator: (meslek) => meslek.isEmpty
                          ? 'Lütfen bir kullanıcı adı oluşturun.'
                          : null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Uzmanlık alanınız",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (meslek) {
                        setState(() => profession = meslek);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      controller: universityController,
                      validator: (uni) => uni.isEmpty
                          ? 'Mezun olduğunuz üniversiteyi giriniz.'
                          : null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Mezun olduğunuz üniversite",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onChanged: (university) {
                        setState(() => university = university);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: new RaisedButton(
                      onPressed: () => _openFileExplorer(),
                      child: new Text("Dosya yükleyin"),
                    ),
                  ),
                  loading
                      ? Loading()
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: height / 40),
                          child: FlatButton(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 60),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFFFFBF00),
                                ),
                                child: Center(
                                  child: Text(
                                    "İşlemi Tamamla",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  registered();
                                }
                                uploadPsiData();
                                db.uploadImagePsy(_imageFile);
                                db.uploadCVPsy(_pickedFile);
                                db.updatePsiInfo();
                                Navigator.pushNamed(context, 'psikologGiris');
                              }),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  registered() {
    setState(() {
      // flag1==true;
    });
    return flag1;
  }
}

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
