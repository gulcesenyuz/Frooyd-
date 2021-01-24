import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/profile_picture/profile_picture.dart';
import 'package:frooyd/Location/location.dart';
import 'package:frooyd/PSYCH/psy_top_bar/psikolog_topBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:image_cropper/image_cropper.dart';

class AddPost extends StatefulWidget {
  _AddPost createState() => _AddPost();
}

class _AddPost extends State<AddPost> {
  File imageFile;
  File _imageFile;

  //Strings required to save address
  Address address;

  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  bool uploading = false;

  String name = 'name';
  String username = 'username';
  String picture = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getProfileData() async {
    try {
      print("test");
      FirebaseUser user = await _auth.currentUser();
      DocumentSnapshot doc = await Firestore.instance
          .collection("psikologlar")
          .document(user.uid)
          .get();
      setState(() {
        name = doc.data["name"];
        username = doc.data["username"];
        picture = doc.data["picUrl"];
      });
    } catch (e) {
      print("eeeeeeeeeeeeee");
    }
  }

  @override
  initState() {
    //variables with location assigned as 0.0
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState(); //method to call location
    super.initState();
  }

  //method to get Location and save into variables
  initPlatformState() async {
    Address first = await getUserLocation();
    setState(() {
      address = first;
    });
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PsiTopBar.main(width, context),
      bottomNavigationBar: PsiBottomBar.general(context),
      body: _imageFile == null
          ? Center(
              child: IconButton(
                  // padding: EdgeInsets.symmetric(vertical: 15,horizontal: width/2),
                  icon: Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () => {_selectImage(context)}),
            )
          : Container(
              child: ListView(
              children: <Widget>[
                PostForm(
                  picture: picture,
                  imageFile: _imageFile,
                  descriptionController: descriptionController,
                  locationController: locationController,
                  loading: uploading,
                ),
                Divider(), //scroll view where we will show location to users
                (address == null)
                    ? Container()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        child: Row(
                          children: <Widget>[
                            buildLocationButton(address.featureName),
                            buildLocationButton(address.subLocality),
                            buildLocationButton(address.locality),
                            buildLocationButton(address.subAdminArea),
                            buildLocationButton(address.adminArea),
                            buildLocationButton(address.countryName),
                          ],
                        ),
                      ),
                (address == null) ? Container() : Divider(),
                FlatButton(
                    onPressed: postImage,
                    child: Text(
                      "Gönder",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    )),
              ],
            )),
    );
  }

  //method to build buttons with location.
  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          locationController.text = locationName;
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                locationName,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Gönderi oluştur'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Kameraya eriş'),
                onPressed: () async {
                  Navigator.pop(context);
                  PickedFile imageFile = await ImagePicker().getImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  _cropImage(imageFile.path);
                }),
            SimpleDialogOption(
                child: const Text('Galeriden seç'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await ImagePicker().getImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  _cropImage(imageFile.path);
                }),
            SimpleDialogOption(
              child: const Text("Iptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
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

  void clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void postImage() {
    print('post');
    setState(() {
      uploading = true;
    });
    uploadImage(_imageFile).then((String data) {
      postToFireStore(
          picUrl: data,
          description: descriptionController.text,
          location: locationController.text);
    }).then((_) {
      setState(() {
        _imageFile = null;

        uploading = false;
      });
    });
    print('post1');
  }
}

// ignore: must_be_immutable
class PostForm extends StatelessWidget {
  final imageFile;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final bool loading;

  PostForm(
      {picture,
      this.imageFile,
      this.descriptionController,
      this.loading,
      this.locationController});

  String name = 'name';
  String username = 'username';
  String picture = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getProfileData() async {
    try {
      print("test99");
      FirebaseUser user = await _auth.currentUser();
      DocumentSnapshot doc = await Firestore.instance
          .collection("psikologlar")
          .document(user.uid)
          .get();
      name = doc.data["name"];
      username = doc.data["username"];
      picture = doc.data["picUrl"];
    } catch (e) {
      print("eeeeeeeeeeeeee");
    }
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        SizedBox(
          height: height / 20,
        ),
        Container(
          width: width / 2,
          child: AspectRatio(
            aspectRatio: 487 / 451,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                alignment: FractionalOffset.topCenter,
                image: FileImage(imageFile),
              )),
            ),
          ),
        ),
        SizedBox(
          height: height / 20,
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            buildProfileImage(picture, 25), // current user
            Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: descriptionController, // yazı yaz
                decoration: InputDecoration(
                    hintText: "Buraya yaz...", border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: height / 20,
            ),
          ],
        ),
        SizedBox(
          height: height / 10,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                  hintText: "Lokasyon seç", border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }
}

Future<String> uploadImage(var imageFile) async {
  var uuid = Uuid().v1();

  StorageReference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
  StorageUploadTask uploadTask = ref.putFile(imageFile);

  String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  return downloadUrl;
}

void postToFireStore(
    {String picUrl, String location, String description}) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user = await _auth.currentUser();

  var reference = Firestore.instance
      .collection('psikologlar')
      .document(user.uid)
      .collection("feed_posts");

  DocumentSnapshot doc = await Firestore.instance
      .collection("psikologlar")
      .document(user.uid)
      .get();

  String username = doc.data["username"];

  reference.add({
    "username": username,
    "location": location,
    "likes": {},
    "post_owner": user.uid,
    "picUrl": picUrl,
    "description": description,
    "timestamp": DateTime.now(),
  }).then((DocumentReference doc) {
    String docId = doc.documentID;
    reference.document(user.uid).updateData({"postId": docId});
  });
}
