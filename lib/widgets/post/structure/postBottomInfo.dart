import 'package:flutter/material.dart';
import 'package:lumiere/utils/functions.dart';
import 'package:lumiere/utils/global.dart';
import 'package:lumiere/widgets/comments/commentList.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/classes/User.dart';
import '../../../utils/global.dart';

class PostBottomInfo extends StatefulWidget {
  final String postId;
  List likes;
  final int comments;
  final String userId;

  PostBottomInfo(this.postId, this.likes, this.comments, this.userId);

  @override
  _PostBottomInfoState createState() => _PostBottomInfoState();
}

class _PostBottomInfoState extends State<PostBottomInfo> {
  List likes = [];
  int comments;
  Image likeWhite = Image.asset("assets/likewhite2.png", height: 80, width: 50);
  Image likeRed = Image.asset("assets/likered.png", height: 80, width: 50);
  Image likeRef;

  void initState() {
    super.initState();
    widget.likes.forEach((element) {
      this.likes.add(element);
    });
    this.comments = widget.comments;
    checkIfAlreadyLiked();
  }

  void checkIfAlreadyLiked() {
    if (this.likes.contains(CURRENTUSER.id)) {
      setState(() {
        this.likeRef = likeRed;
      });
    } else {
      setState(() {
        this.likeRef = likeWhite;
      });
    }
  }

  addLike() {
    print(this.likes);
    if (this.likes.contains(CURRENTUSER.id)) {
      setState(() {
        this.likes.remove(CURRENTUSER.id);
        this.likeRef = likeWhite;
      });
    } else {
      if(widget.userId != CURRENTUSER.id){
        String notificationId = Uuid().v4();
        FEED
            .document(widget.userId)
            .collection('feedItems')
            .document(notificationId)
            .setData({
          "typeOfInteraction": "like",
          "username": CURRENTUSER.username,
          "userId": CURRENTUSER.id,
          "userProfileImage": CURRENTUSER.photoURL,
          "postID": widget.postId
        });
      }
      setState(() {
        this.likes.add(CURRENTUSER.id);
        this.likeRef = likeRed;
      });
    }
    POST.document(widget.postId).updateData({"likes": this.likes});
  }

  changeCommentsNumber() {
    setState(() {
      this.comments += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => changePage(
                          context,
                          CommentsTab(widget.postId, widget.comments,
                              this.changeCommentsNumber, widget.userId),
                          check: true),
                      child: Icon(
                        Icons.comment,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(this.comments.toString())
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    child: GestureDetector(onTap: this.addLike, child: likeRef),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Text(this.likes.length.toString())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
