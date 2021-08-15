import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/utils/classes/Post.dart';

import 'package:lumiere/widgets/post/post.dart';
import 'package:lumiere/widgets/results/childWidget.dart';

import '../../utils/global.dart';
import '../../widgets/loader/loading.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Future<QuerySnapshot> _postsList;

  void _fetchPosts() {
    Future<QuerySnapshot> posts =
        FEED.document(CURRENTUSER.id).collection("feedTimeline").orderBy("timestamp", descending: true).getDocuments();
    setState(() {
      _postsList = posts;
    });
  }

  void initState() {
    super.initState();
    this._fetchPosts();
  }

  Future<List<PostObject>> _getPosts(Future<QuerySnapshot> postIds) async {
    List<PostObject> allPosts = [];
    QuerySnapshot tmp = await postIds;
    List<DocumentSnapshot> tmpList = tmp.documents;
    for (var tmpItem in tmpList) {
      DocumentSnapshot post = await Firestore.instance
          .collection('posts')
          .document(tmpItem.documentID)
          .get();
      post.data['id'] = tmpItem.documentID;
      PostObject tmpPost = PostObject.fromDocument(post);
      allPosts.add(tmpPost);
    }
    return allPosts;
  }

  Widget _childWidget(PostObject item) {
    return Post(
        item.username,
        item.timestamp,
        item.avatarUrl,
        item.description,
        item.mediaUrl,
        false,
        item.id,
        item.userId,
        item.likes,
        item.comments,
        item.mood,
        item.rating);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: this._postsList == null
            ? circularProgress()
            : FutureBuilder(
                future: this._getPosts(this._postsList),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return ChildWidget(snapshot.data, this._childWidget);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ));
  }
}
