import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

profilePicture(imageFile, double radius) {
  return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: imageFile != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                imageFile,
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50)),
              width: 100,
              height: 100,
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey[800],
              ),
            ));
}

Widget buildProfileImage(picture, double radius) {
  return Center(
    child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: picture != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 100,
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl: picture,
                    // imageUrl: picture,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50)),
                width: 100,
                height: 100,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[800],
                ),
              )),
  );
}
