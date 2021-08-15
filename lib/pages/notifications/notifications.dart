import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/pages/posts/singlePost.dart';
import 'package:lumiere/utils/functions.dart';

import 'package:lumiere/utils/global.dart';
import 'package:lumiere/widgets/custom/avatarHeader.dart';
import 'package:lumiere/widgets/loader/loading.dart';
import 'package:lumiere/pages/profile/profile.dart';
import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/widgets/custom/header.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  getNotifications() async {
    QuerySnapshot snapshot = await FEED
        .document(CURRENTUSER.id)
        .collection('feedItems')
        .limit(50)
        .getDocuments();
    List<NotificationModel> notifications = [];
    snapshot.documents.forEach((doc) {
      notifications.add(NotificationModel.fromDocument(doc));
    });
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, "Notifications"),
      body: Container(
          child: FutureBuilder(
        future: getNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class NotificationModel extends StatelessWidget {
  String username;
  String userId;
  String typeOfInteraction;
  String url;
  String postID;
  String userProfileImage;
  String commentData;

  NotificationModel({
    this.username,
    this.userId,
    this.typeOfInteraction,
    this.url,
    this.postID,
    this.userProfileImage,
    this.commentData,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel(
      username: doc['username'],
      userId: doc['userId'],
      typeOfInteraction: doc['typeOfInteraction'],
      url: doc['url'],
      postID: doc['postID'],
      userProfileImage: doc['userProfileImage'],
      commentData: doc['commentData'],
    );
  }

  typeOfMedia() {
    if (typeOfInteraction == "like" || typeOfInteraction == "comment") {
      mediaPreview = Text('');
      print(this.postID);
    } else {
      mediaPreview = Text('');
    }

    if (typeOfInteraction == "like") {
      activityItemText = "liked your review";
    } else if (typeOfInteraction == "follow") {
      activityItemText = "followed you";
    } else if (typeOfInteraction == "comment") {
      activityItemText = "replied to your review";
    }
  }

  parseUser(BuildContext context, String id) {
    User u = getUser(id);
    showProfile(context, u);
  }

  showProfile(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(user.id),
      ),
    );
  }

  getUser(String userID) async {
    DocumentSnapshot snapshot = await USERS.document(userID).get();

    User user = User.fromDocument(snapshot);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    typeOfMedia();

    print(this.postID);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: GestureDetector(
            onTap: () =>
                {
                 if(typeOfInteraction == "like" || typeOfInteraction == "comment"){
                   changePage(context, SinglePost(this.postID), check: true),
                 }
                 else{
                   changePage(context, ProfilePage(userId), check: true),
                 }
                },
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityItemText',
                    ),
                  ]),
            ),
          ),
          leading: //AvatarHeader(username, " ", userProfileImage, null, userId),
              CircleAvatar(
            backgroundImage: NetworkImage(userProfileImage),
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
