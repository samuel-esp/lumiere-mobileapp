import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:lumiere/pages/posts/singlePost.dart';
import 'package:lumiere/utils/functions.dart';
import 'package:lumiere/widgets/post/structure/postBottomInfo.dart';
import 'package:lumiere/widgets/post/structure/postCaption.dart';
import 'package:lumiere/widgets/post/structure/postContent.dart';
import 'package:lumiere/widgets/custom/avatarHeader.dart';

class Post extends StatefulWidget {
  final String name;
  final Timestamp timestamp;
  final String avatarUrl;
  final String caption;
  final String postMediaUrl;
  final bool singlePost;
  final String id;
  final String userId;
  final int comments;
  List likes;
  final String mood;
  final String rating;

  Post(
      this.name,
      this.timestamp,
      this.avatarUrl,
      this.caption,
      this.postMediaUrl,
      this.singlePost,
      this.id,
      this.userId,
      this.likes,
      this.comments,
      this.mood,
      this.rating);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final iconWidget = Container(
    margin: EdgeInsets.only(right: 8.0),
    child: Icon(
      Icons.more_horiz,
      size: 30,
      color: Colors.grey,
    ),
  );

  _goToPostDetail(BuildContext context) {
    if (!widget.singlePost) {
      changePage(context, SinglePost(widget.id), check: true);
    }
  }

  Widget _childContent() {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        widget.timestamp.microsecondsSinceEpoch);
    DateTime now = DateTime.now();
    int difference = now.difference(date).inHours;
    String timestamp = difference.toString() + " hours ago";
    return Card(
      margin: EdgeInsets.only(top: 0.5, left: 20.0, right: 20.0, bottom: 4.0),
      child: Column(
        children: <Widget>[
          AvatarHeader(widget.name, timestamp, widget.avatarUrl, iconWidget,
              widget.userId),
          PostCaption(widget.caption, widget.singlePost),
          PostContent(widget.postMediaUrl),
          widget.singlePost
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: <Widget>[
                            Text("⭐ " + widget.rating + "/5",
                                style: TextStyle(fontSize: 15.0)),
                            Padding(padding: EdgeInsets.only(left: 15.0)),
                            Text(widget.mood, style: TextStyle(fontSize: 25.0)),
                          ],
                        ),
                      ),
                    ),
                    PostBottomInfo(widget.id, widget.likes, widget.comments,
                        widget.userId),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !widget.singlePost
        ? GestureDetector(
            onTap: () => this._goToPostDetail(context),
            child: this._childContent(),
          )
        : ListView(
            scrollDirection: Axis.vertical,
            children: [this._childContent()],
          );
  }
}
