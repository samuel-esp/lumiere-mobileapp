import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/welcome.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:lumiere/utils/global.dart';
import 'package:lumiere/widgets/loader/loading.dart';

class EditProfile extends StatefulWidget {
  final Function updateUser;
  EditProfile(this.updateUser);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  bool _nameValid = true;
  bool _bioValid = true;
  File fileP;
  File fileC;
  User user;
  String profilePath = Uuid().v4();
  String coverPath = Uuid().v4();
  String profileString;
  String coverString;

  @override
  void initState() {
    super.initState();
    getUser();
    profileString = CURRENTUSER.photoURL;
    coverString = CURRENTUSER.coverURL;
  }

  takePhotoP() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 80,
      maxWidth: 80,
    );
    setState(() {
      this.fileP = file;
    });
    if (fileP != null) submitP();
  }

  fromGalleryP() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.fileP = file;
    });
    if (fileP != null) submitP();
  }

  takePhotoC() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 360,
    );
    setState(() {
      this.fileC = file;
    });
    if (fileC != null) submitC();
  }

  fromGalleryC() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.fileC = file;
    });
    if (fileC != null) submitC();
  }

  compressImageP() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(fileP.readAsBytesSync());
    final compressedImageFile = File('$path/img_$profilePath.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    print("compressed");
    setState(() {
      fileP = compressedImageFile;
    });
  }

  compressImageC() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(fileC.readAsBytesSync());
    final compressedImageFile = File('$path/img_$coverPath.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    print("compressed");
    setState(() {
      fileC = compressedImageFile;
    });
  }

  selectImageP(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Change Profile pic"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: takePhotoP,
              ),
              SimpleDialogOption(
                child: Text("Image From Gallery"),
                onPressed: fromGalleryP,
              ),
              SimpleDialogOption(
                child: Text("Go Back"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  selectImageC(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Change Cover pic"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: takePhotoC,
              ),
              SimpleDialogOption(
                child: Text("Image From Gallery"),
                onPressed: fromGalleryC,
              ),
              SimpleDialogOption(
                child: Text("Go Back"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  submitP() async {
    print("submit");
    await compressImageP();
    print("submit");
    String url = await uploadImageP(fileP);
    setState(() {
      fileP = null;
      profileString = url;
      profilePath = Uuid().v4();
    });
  }

  Future<String> uploadImageP(imageFile) async {
    StorageUploadTask uploadTask =
    STORAGE.child("post$profilePath.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    print("upload");
    return downloadUrl;
  }

  submitC() async {
    print("submit");
    await compressImageC();
    print("submit");
    String url = await uploadImageC(fileC);
    setState(() {
      fileC = null;
      coverString = url;
      coverPath = Uuid().v4();
    });
  }

  Future<String> uploadImageC(imageFile) async {
    StorageUploadTask uploadTask =
    STORAGE.child("post$coverPath.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    print("upload cover");
    return downloadUrl;
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await USERS.document(CURRENTUSER.id).get();
    user = User.fromDocument(doc);
    nameController.text = user.name;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Display Name",
            style: TextStyle(color: Color.fromRGBO(230, 51, 51, 1)),
          ),
        ),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _nameValid ? null : "Name too short",
          ),
        ),
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Color.fromRGBO(230, 51, 51, 1)),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio too long",
          ),
        ),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      nameController.text.trim().length < 3 || nameController.text.isEmpty
          ? _nameValid = false
          : _nameValid = true;
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_nameValid && _bioValid) {
      widget.updateUser();
      USERS.document(CURRENTUSER.id).updateData({
        "name": nameController.text,
        "bio": bioController.text,
        "photoURL": profileString,
        "coverURL": coverString,
      });

      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  logout() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(context),
            icon: Icon(Icons.done,
                size: 30.0, color: Color.fromRGBO(230, 51, 51, 1)),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              width: 360,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(coverString),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 92.0),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            selectImageP(context);
                          },
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor:
                            Color.fromRGBO(230, 51, 51, 1),
                            backgroundImage: NetworkImage(profileString),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            selectImageC(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 205.0),
                            child: Icon(
                              Icons.create,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                buildNameField(),
                buildBioField(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, left: 70.0, right: 70.0),
            child: RaisedButton(
              onPressed: updateProfileData,
              color: Color.fromRGBO(230, 51, 51, 1),
              focusElevation: 10.0,
              shape: StadiumBorder(
                side: BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(230, 51, 51, 1),
                ),
              ),
              child: Text(
                "Update Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
            child: FlatButton.icon(
              onPressed: logout,
              icon: Icon(Icons.cancel,
                  color: Color.fromRGBO(230, 51, 51, 1)),
              label: Text(
                "Logout",
                style: TextStyle(
                    color: Color.fromRGBO(230, 51, 51, 1),
                    fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
