import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/pages/friendship/friendship.dart';
import 'package:lumiere/utils/classes/Post.dart';

import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/utils/functions.dart';
import 'package:lumiere/utils/global.dart';
import 'package:lumiere/widgets/custom/header.dart';
import 'package:lumiere/widgets/loader/loading.dart';
import 'package:lumiere/widgets/post/post.dart';
import 'package:uuid/uuid.dart';

import 'editProfile.dart';

class ProfilePage extends StatefulWidget {
  final String profileId;

  ProfilePage(this.profileId);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  bool isLoading = false;
  User userInView;
  List<String> posts = [];
  List<PostObject> postsList = [];
  List<String> followers = [];
  List<String> followings = [];

  @override
  void initState() {
    super.initState();
    this._getUser(widget.profileId, false);
    if (widget.profileId != CURRENTUSER.id) {
      this._checkIfFollowing();
    }
    this._getProfilePosts();
    this._getFriendship("userFollowers");
    this._getFriendship("userFollowing");
  }

  Future<void> _checkIfFollowing() async {
    DocumentSnapshot doc = await FOLLOWERS
        .document(widget.profileId)
        .collection('userFollowers')
        .document(CURRENTUSER.id)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  Future<List<PostObject>> _getPosts(List<String> postIds) async {
    List<PostObject> allPosts = [];
    for (var tmpItem in postIds) {
      DocumentSnapshot post =
          await Firestore.instance.collection('posts').document(tmpItem).get();
      post.data['id'] = tmpItem;
      PostObject tmpPost = PostObject.fromDocument(post);
      allPosts.add(tmpPost);
    }
    return allPosts;
  }

  Future<void> _getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await USERS
        .document(widget.profileId)
        .collection('posts')
        .orderBy("timestamp", descending: true)
        .getDocuments();
    setState(() {
      this.posts = snapshot.documents.map((doc) => doc.documentID).toList();
    });
    this._getPosts(this.posts);
  }

  Future<void> _getFriendship(String collectionType) async {
    CollectionReference tmp;
    if (collectionType == 'userFollowers') {
      tmp = FOLLOWERS;
    } else {
      tmp = FOLLOWINGS;
    }
    QuerySnapshot snapshot = await tmp
        .document(widget.profileId)
        .collection(collectionType)
        .getDocuments();
    if (collectionType == "userFollowers") {
      setState(() {
        this.followers =
            snapshot.documents.map((doc) => doc.documentID).toList();
      });
    } else {
      setState(() {
        this.followings =
            snapshot.documents.map((doc) => doc.documentID).toList();
      });
    }
  }

  Future<void> _getUser(String userId, bool check) async {
    DocumentSnapshot snapshot = await USERS.document(userId).get();
    User user = User.fromDocument(snapshot);
    print(user);
    if (check) {
      setState(() {
        CURRENTUSER = user;
      });
    } else {
      setState(() {
        this.userInView = user;
      });
    }
  }

  Widget buildCountColumn(String label, int count) {
    return GestureDetector(
      onTap: () => changePage(
          context,
          FriendshipTab(widget.profileId,
              label == "follower" ? "userFollowers" : "userFollowing"),
          check: true),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            count.toString(),
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            child: Text(
              label,
              style: TextStyle(
                color: Color.fromRGBO(230, 51, 51, 1),
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 360,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(CURRENTUSER.id == widget.profileId
                    ? CURRENTUSER.coverURL
                    : this.userInView.coverURL),
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
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.orange,
                        backgroundImage: NetworkImage(
                            CURRENTUSER.id == widget.profileId
                                ? CURRENTUSER.photoURL
                                : this.userInView.photoURL),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Text(
                                CURRENTUSER.id == widget.profileId
                                    ? CURRENTUSER.name
                                    : this.userInView.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                CURRENTUSER.id == widget.profileId
                                    ? '@' + CURRENTUSER.username
                                    : '@' + this.userInView.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 14.0, bottom: 8.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                CURRENTUSER.id == widget.profileId
                    ? CURRENTUSER.bio
                    : this.userInView.bio,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buildCountColumn("post", this.posts.length),
                    buildCountColumn("follower", this.followers.length),
                    buildCountColumn("following", this.followings.length),
                    buildProfileButton(),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1.0,
            width: 360.0,
            color: Colors.black,
          ),
        ],
      ),
    );
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
    return Scaffold(
        appBar: header(context, "Profile"),
        body: this.userInView == null
            ? circularProgress()
            : ListView(children: <Widget>[
                buildProfileHeader(),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: this.postsList == null
                        ? circularProgress()
                        : FutureBuilder(
                            future: this._getPosts(this.posts),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    var item = snapshot.data[index];
                                    return _childWidget(item);
                                  },
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ))
              ]));
  }

  Container buildButton({String text, Function function}) {
    return Container(
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 160.0,
          height: 26.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(230, 51, 51, 1),
            border: Border.all(color: Color.fromRGBO(230, 51, 51, 1)),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  void _handlePressFriendship(bool check) async {
    if (widget.profileId != CURRENTUSER.id) {
      final followHandler = FOLLOWERS
          .document(widget.profileId)
          .collection('userFollowers')
          .document(CURRENTUSER.id);
      final followingHandler = FOLLOWINGS
          .document(CURRENTUSER.id)
          .collection('userFollowing')
          .document(widget.profileId);
      String notificationId = Uuid().v4();
      final notificationHandler = FEED
          .document(widget.profileId)
          .collection('feedItems')
          .document(notificationId);

      if (check) {
        followHandler.get().then((doc) => this._handleDelete(doc));
        followingHandler.get().then((doc) => this._handleDelete(doc));
        notificationHandler.get().then((doc) => this._handleDelete(doc));
        QuerySnapshot postsTimeline = await FEED.document(CURRENTUSER.id).collection("feedTimeline").getDocuments();
        List<DocumentSnapshot> tmpList = postsTimeline.documents;
        for (var tmpItem in tmpList) {
          if(tmpItem.data['ownerId'] == widget.profileId){
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
          Timestamp last = postsTimeline.documents.last.data['timestamp'];
          QuerySnapshot postsTimelineTmp = await USERS.document(widget.profileId).collection("posts").where("timestamp", isGreaterThanOrEqualTo: last).getDocuments();
          List<DocumentSnapshot> tmpList = postsTimelineTmp.documents;
          for (var tmpItem in tmpList) {
            FEED.document(CURRENTUSER.id).collection("feedTimeline")
            .document(tmpItem.documentID).setData({
              "timestamp": tmpItem.data['timestamp'],
              "ownerId": widget.profileId
            });
          }
        }
        else{
          QuerySnapshot postsTimelineTmp = await USERS.document(widget.profileId).collection("posts").getDocuments();
          List<DocumentSnapshot> tmpList = postsTimelineTmp.documents;
          for (var tmpItem in tmpList) {
            FEED.document(CURRENTUSER.id).collection("feedTimeline")
                .document(tmpItem.documentID).setData({
              "timestamp": tmpItem.data['timestamp'],
              "ownerId": widget.profileId
            });
          }
        }
      }
      setState(() {
        isFollowing = !isFollowing;
      });
    }
  }

  void _handleDelete(doc) {
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = CURRENTUSER.id == widget.profileId;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
        function: () => changePage(
            context, EditProfile(() => this._getUser(CURRENTUSER.id, true)),
            check: true),
      );
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        function: () => this._handlePressFriendship(true),
      );
    } else if (!isFollowing) {
      return buildButton(
        text: "Follow",
        function: () => this._handlePressFriendship(false),
      );
    }
  }
}
