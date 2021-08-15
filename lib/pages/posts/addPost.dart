import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumiere/utils/global.dart';
import 'package:lumiere/widgets/loader/loading.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:image/image.dart' as Im;

class AddPost extends StatefulWidget {
  //final User currentUser;

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File file;
  String rating = "0";
  String mood = " ";
  IconData checkedRating = (Icons.check_box_outline_blank);
  IconData checkedMood = (Icons.check_box_outline_blank);
  bool isUploading = false;
  String postId = Uuid().v4();
  TextEditingController caption = TextEditingController();

  takePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  fromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Review"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: () => takePhoto,
              ),
              SimpleDialogOption(
                child: Text("Image From Gallery"),
                onPressed: fromGallery,
              ),
              SimpleDialogOption(
                child: Text("Go Back"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container insertImageScreen() {
    return Container(
      //appBar: header(context, "Add Post"),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/newpostpopcorn.png', height: 260.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                "Upload Review Image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              color: Colors.black,
              onPressed: () => selectImage(context),
            ),
          )
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  final List<String> ratingItems = ["1", "2", "3", "4", "5"];

  Widget ratingItemPicker() {
    return CupertinoPicker(
      itemExtent: 60.0,
      backgroundColor: CupertinoColors.white,
      onSelectedItemChanged: (index) {
        setState(() {
          rating = ratingItems[index].toString();
          checkedRating = (Icons.check_box);
        });
      },
      children: new List<Widget>.generate(ratingItems.length, (index) {
        return new Center(
          child: Text(
            ratingItems[index],
            style: TextStyle(fontSize: 22.0),
          ),
        );
      }),
    );
  }

  final List<Emoji> moodItems = [
    Emoji('heart', '❤️'),
    Emoji('sad', '😢'),
    Emoji('funny', '🤣'),
    Emoji('anxious', '😰'),
    Emoji('scared', '😱'),
    Emoji('adventurous', '🤠'),
    Emoji('exploding head', '🤯'),
    Emoji('nerd', '🤓'),
  ];

  Widget moodItemPicker() {
    return CupertinoPicker(
      itemExtent: 60.0,
      backgroundColor: CupertinoColors.white,
      onSelectedItemChanged: (index) {
        setState(() {
          mood = moodItems[index].code;
          checkedMood = (Icons.check_box);
        });
      },
      children: new List<Widget>.generate(moodItems.length, (index) {
        return new Center(
          child: Text(
            moodItems[index].code,
            style: TextStyle(fontSize: 22.0),
          ),
        );
      }),
    );
  }

  createFirebasePost({String url, String caption, String mood, String rating}) {
    Timestamp now = Timestamp.now();
    POST.document(postId).setData({
      "avatarUrl": CURRENTUSER.photoURL,
      "timestamp": now,
      "userId": CURRENTUSER.id, //widget.currentUser.id
      "username": CURRENTUSER.username, //widget.currentUser.username
      "mediaUrl": url,
      "description": caption,
      "mood": mood,
      "likes": [],
      "comments": 0,
      "rating": rating,
    });
    USERS.document(CURRENTUSER.id).collection("posts").document(postId).setData({
      "timestamp": now
    });
    sendPostsToTimeline(now, postId);
  }

  sendPostsToTimeline(Timestamp now, String postId) async {
    var query = await FOLLOWERS
        .document(CURRENTUSER.id)
        .collection('userFollowers')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              FEED
                  .document(element.documentID)
                  .collection('feedTimeline')
                  .document(postId)
                  .setData({"timestamp": now, "ownerId": CURRENTUSER.id});
            }));
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        STORAGE.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  submit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String url = await uploadImage(file);
    createFirebasePost(
        url: url, caption: caption.text, mood: mood, rating: rating);
    caption.clear();
    setState(() {
      file = null;
      isUploading = false;
      rating = "0";
      mood = " ";
      postId = Uuid().v4();
    });
  }

  uploadPost() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => submit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(" "),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(CURRENTUSER.photoURL),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: caption,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Write your review",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Container(
              width: 300.0,
              height: 100.0,
              alignment: Alignment.centerLeft,
              child: RaisedButton.icon(
                label: Text(
                  "Tap To Rate   ",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.black,
                onPressed: () async {
                  await showModalBottomSheet<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return ratingItemPicker();
                    },
                  );
                },
                icon: Icon(
                  checkedRating,
                  color: Colors.white,
                ),
              ),
            ),
            trailing: Text(' $rating / 5',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Divider(height: 2.0),
          ListTile(
            leading: Container(
              width: 300.0,
              height: 100.0,
              alignment: Alignment.centerLeft,
              child: RaisedButton.icon(
                label: Text(
                  "Tap For Mood",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.black,
                onPressed: () async {
                  await showModalBottomSheet<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return moodItemPicker();
                    },
                  );
                },
                icon: Icon(
                  checkedMood,
                  color: Colors.white,
                ),
              ),
            ),
            trailing:
                Text(' $mood', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
    child: file == null ? insertImageScreen() : uploadPost(),
  );
}
