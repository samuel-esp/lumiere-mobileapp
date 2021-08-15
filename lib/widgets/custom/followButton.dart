import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/utils/global.dart';

import 'package:lumiere/widgets/custom/customButton.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class FollowButton extends StatefulWidget {

   String buttonText;
   Color buttonColor;
   Color textColor;
   Color borderColor;
   bool checkValue;
   String currentUserId;
   String userId;

  FollowButton(this.buttonText, this.buttonColor, this.borderColor, this.textColor, this.checkValue, this.currentUserId, this.userId);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {

  @override
  initState(){
    super.initState();
  }

  void _handleDelete(doc) {
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  void _handlePressSupport(bool check, String currentUserId, String userId) async {

    if (userId != currentUserId){
      final followHandler = FOLLOWERS
          .document(userId)
          .collection('userFollowers')
          .document(currentUserId);
      final followingHandler = FOLLOWINGS
          .document(currentUserId)
          .collection('userFollowing')
          .document(userId);
      String notificationId = Uuid().v4();
      final notificationHandler =
      FEED.document(userId).collection('feedItems').document(notificationId);

      if (check) {
        followHandler.get().then((doc) => this._handleDelete(doc));
        followingHandler.get().then((doc) => this._handleDelete(doc));
        notificationHandler.get().then((doc) => this._handleDelete(doc));
        QuerySnapshot postsTimeline = await FEED.document(CURRENTUSER.id).collection("feedTimeline").getDocuments();
        List<DocumentSnapshot> tmpList = postsTimeline.documents;
        for (var tmpItem in tmpList) {
          if(tmpItem.data['ownerId'] == userId){
            FEED.document(CURRENTUSER.id).collection("feedTimeline").document(tmpItem.documentID).delete();
          }
        }
      } else {
        followHandler.setData({});
        followingHandler.setData({});
        notificationHandler.setData({
          "typeOfInteraction": "follow",
          "username": CURRENTUSER.username,
          "userId": CURRENTUSER.id,
          "userProfileImage": CURRENTUSER.photoURL,
        });
        QuerySnapshot postsTimeline = await FEED.document(CURRENTUSER.id).collection("feedTimeline").getDocuments();
        if(postsTimeline.documents.length > 0){
          Timestamp first = postsTimeline.documents.first.data['timestamp'];
          Timestamp last = postsTimeline.documents.last.data['timestamp'];
          QuerySnapshot postsTimelineTmp = await USERS.document(userId).collection("posts").where("timestamp", isGreaterThanOrEqualTo: last).where("timestamp", isLessThan: first).getDocuments();
          List<DocumentSnapshot> tmpList = postsTimelineTmp.documents;
          for (var tmpItem in tmpList) {
            FEED.document(CURRENTUSER.id).collection("feedTimeline")
                .document(tmpItem.documentID).setData({
              "timestamp": tmpItem.data['timestamp'],
              "ownerId": userId
            });
          }
        }
        else{
          QuerySnapshot postsTimelineTmp = await USERS.document(userId).collection("posts").getDocuments();
          List<DocumentSnapshot> tmpList = postsTimelineTmp.documents;
          for (var tmpItem in tmpList) {
            FEED.document(CURRENTUSER.id).collection("feedTimeline")
                .document(tmpItem.documentID).setData({
              "timestamp": tmpItem.data['timestamp'],
              "ownerId": userId
            });
          }
        }
      }
    }

  }

  void handlePress() async {
    if(widget.checkValue){
      setState(() {widget.buttonText =  "Follow"; widget.buttonColor = Color.fromRGBO(230, 51, 51, 1); widget.textColor = Colors.white; widget.borderColor = Color.fromRGBO(230, 51, 51, 1); widget.checkValue = !widget.checkValue; });
    }else{
      setState(() {widget.buttonText =  "Unfollow"; widget.buttonColor = Colors.black; widget.textColor = Colors.white; widget.borderColor = Colors.black; widget.checkValue = !widget.checkValue; });
    }
    this._handlePressSupport(!widget.checkValue, widget.currentUserId, widget.userId);

  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(widget.buttonText, widget.buttonColor, widget.borderColor, widget.textColor, handlePress, EdgeInsets.fromLTRB(0.0, 0, 0, 0), 15);
  }
}
