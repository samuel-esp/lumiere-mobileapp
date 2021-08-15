import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/utils/classes/Comment.dart';
import 'package:lumiere/utils/global.dart';

import 'package:lumiere/widgets/comments/commentWidget.dart';
import 'package:lumiere/widgets/custom/header.dart';
import 'package:lumiere/widgets/loader/loading.dart';
import 'package:uuid/uuid.dart';


class CommentsTab extends StatefulWidget {

  final String postId;
  final int commentsNumber;
  final Function addComments;
  final String userId;

  CommentsTab(this.postId, this.commentsNumber, this.addComments, this.userId);

  @override
  _CommentsTabState createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {

  Future<QuerySnapshot> _postsCommentsList;
  Future<List<CommentObject>> commentsList;
  TextEditingController commentsController = TextEditingController();
  

  void _fetchPostsComments() {
    Future<QuerySnapshot> posts = POST.document(widget.postId).collection("commentsList").orderBy("timestamp", descending: false).getDocuments();
    setState(() {
      _postsCommentsList = posts;
    });
  }

  Future<List<CommentObject>> _getPostsComments(Future<QuerySnapshot> postCommentsIds) async {
    List<CommentObject> allComments = [];
    QuerySnapshot tmp = await postCommentsIds;
    List<DocumentSnapshot> tmpList = tmp.documents;
    tmpList.forEach((element) {
      DocumentSnapshot post = element;
      post.data['id'] = element.documentID;
      CommentObject tmpPost = CommentObject.fromDocument(post);
      allComments.add(tmpPost);
    });
    return allComments;
  }

  void initState(){
    super.initState();
    this._fetchPostsComments();
    setState(() {
      commentsList = this._getPostsComments(this._postsCommentsList);
    });
  }


  Widget _childWidget(CommentObject item){
    return CommentWidget(item.username, item.timestamp, item.avatarUrl, item.text, item.id, item.userId);
  }

  addComment(String comment) {
    if(widget.userId != CURRENTUSER.id){
      String notificationId = Uuid().v4();
      FEED.document(widget.userId).collection('feedItems').document(notificationId)
          .setData({
        "typeOfInteraction": "comment",
        "username": CURRENTUSER.username,
        "userId": CURRENTUSER.id,
        "userProfileImage": CURRENTUSER.photoURL,
        "postID": widget.postId
      });
      // TODO set notification
    }
    commentsController.clear();
    String commentId = Uuid().v4();
    Timestamp now = Timestamp.now();
    POST.document(widget.postId).collection("commentsList").document(commentId).setData({"avatarUrl": CURRENTUSER.photoURL,
      "text": comment,
      "timestamp": now,
      "userId": CURRENTUSER.id,
      "username": CURRENTUSER.username
    });
    CommentObject tmpComment = CommentObject(id: commentId, username: CURRENTUSER.username, timestamp: now, avatarUrl: CURRENTUSER.photoURL, text: comment, userId: CURRENTUSER.id);
    POST
        .document(widget.postId)//post sh
        .updateData({'comments': widget.commentsNumber + 1});
    widget.addComments();
    commentsList.then((value) => setState((){
      value.add(tmpComment);
    }));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, "Comments"),
        body: Container(
          child: Column(
          children: [
            Expanded(
              child: this._postsCommentsList == null ? circularProgress() : FutureBuilder(
                  future: commentsList,
                  builder: (BuildContext context,snapshot) {
                    if(snapshot.hasData && snapshot.connectionState == ConnectionState.done) {return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data[index];
                        return _childWidget(item);
                      },
                    );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              )
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: TextFormField(
                controller: commentsController,
                onFieldSubmitted: this.addComment,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.comment,
                        color: Colors.grey,
                      ), // icon is 48px widget.
                    ),
                    hintText: "Add a comment",
                    hintStyle: TextStyle(fontSize: 20)),
              ),
            )
    ],
        )));
  }
}
