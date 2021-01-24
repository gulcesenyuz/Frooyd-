import 'dart:io';

import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frooyd/COMMON/app_bars/custom_bar.dart';
import 'package:frooyd/COMMON/profile_picture/profile_picture.dart';
import 'package:frooyd/SERVICES/database.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePageUser extends StatefulWidget {
  @override
  _EditProfilePageUserState createState() => _EditProfilePageUserState();
}

class _EditProfilePageUserState extends State<EditProfilePageUser> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final Database db = new Database();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File _imageFile;
  String imagepath;
  String picture;

  @override
  // ignore: must_call_super
  void initState() {
    getProfileData();
  }

  Future<File> imgFromCamera() async {
    final PickedFile imageFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (imageFile != null) {
        _imageFile = File(imageFile.path);
      } else {
        _imageFile = File(picture);
      }
    });

    return _imageFile;
  }

  Future imgFromGallery() async {
    PickedFile imageFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (imageFile != null) {
        _imageFile = File(imageFile.path);
      } else {
        _imageFile = File(picture);
      }
    });
    return _imageFile;
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

  void getProfileData() async {
    try {
      print("test999999");
      FirebaseUser user = await _auth.currentUser();
      DocumentSnapshot doc =
          await Firestore.instance.collection("users").document(user.uid).get();
      setState(() {
        nameController.text = doc.data['name'];
        usernameController.text = doc.data['username'];
        bioController.text = doc.data['bio'];
        picture = doc.data["picUrl"];
        print(picture + '***************************************');
      });
    } catch (e) {
      print("eeeeeeeeeeeeee");
    }
  }

  changeProfilePhoto(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Changing your profile photo has not been implemented yet'),
              ],
            ),
          ),
        );
      },
    );
  }

  applyChanges() async {
    FirebaseUser user = await _auth.currentUser();
    print('test123');
    Firestore.instance.collection('users').document(user.uid).updateData({
      "name": nameController.text,
      "bio": bioController.text,
      "username": usernameController.text,
      // "picUrl": _imageFile,
    });
  }

  Widget buildTextField({String name, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar.withBackButton(width, context),
      bottomNavigationBar: BottomBarCustom.general(context),
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: GestureDetector(
                    onTap: () {
                      showPicker(context);
                    },
                    child: buildProfileImage(picture, 55)),
              ),
              Text(
                "Fotoğraf değiştir",
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    buildTextField(
                        name: "Ad Soyad", controller: nameController),
                    buildTextField(
                        name: "Kullanıcı Adı", controller: usernameController),
                    buildTextField(
                        name: "Biyografi", controller: bioController),
                  ],
                ),
              ),
              SizedBox(
                child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      applyChanges();
                      imagepath = await db.uploadImageUser(_imageFile);
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
