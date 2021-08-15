import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lumiere/utils/classes/Post.dart';
import 'package:lumiere/widgets/custom/header.dart';
import 'package:lumiere/widgets/post/post.dart';

import '../../utils/global.dart';
import '../../widgets/loader/loading.dart';

class SinglePost extends StatefulWidget {
  final String postId;

  const SinglePost(this.postId, {Key key}) : super(key: key);

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  PostObject _post;

  int likesNumber;
  int commentsNumber;

  void _fetchPost() async {
    Future<DocumentSnapshot> post = POST.document(widget.postId).get();
    post.then((value) => setState(() {
          value.data['id'] = widget.postId;
          _post = PostObject.fromDocument(value.data);
        }));
  }

  void initState() {
    super.initState();
    this._fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, "SinglePost"),
      body: Container(
          margin: EdgeInsets.only(top: 10),
          child: this._post == null
              ? circularProgress()
              : Post(
                  this._post.username,
                  this._post.timestamp,
                  this._post.avatarUrl,
                  this._post.description,
                  this._post.mediaUrl,
                  true,
                  this._post.id,
                  this._post.userId,
                  this._post.likes,
                  this._post.comments,
                  this._post.mood,
                  this._post.rating)),
    );
  }
}
