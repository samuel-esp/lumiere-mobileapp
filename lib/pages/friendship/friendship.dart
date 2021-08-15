import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/utils/global.dart';

import 'package:lumiere/widgets/custom/avatarHeader.dart';
import 'package:lumiere/widgets/custom/header.dart';

import 'package:lumiere/widgets/loader/loading.dart';

class FriendshipTab extends StatefulWidget {

  final String userId;
  final String type;

  FriendshipTab(this.userId, this.type);

  @override
  _FriendshipTabState createState() => _FriendshipTabState();
}

class _FriendshipTabState extends State<FriendshipTab> {

  Future<QuerySnapshot> _usersList;

  void _fetchUsersFriendship() {
    CollectionReference tmp;
    if(widget.type == "userFollowers"){
      tmp = FOLLOWERS;
    }
    else{
      tmp = FOLLOWINGS;
    }
    Future<QuerySnapshot> usersIds = tmp.document(widget.userId).collection(widget.type).getDocuments();
    setState(() {
      _usersList = usersIds;
    });
  }

  Future<List<User>> _getUserFriendship(Future<QuerySnapshot> userIDS) async {
    List<User> allUsers = [];
    QuerySnapshot tmp = await userIDS;
    List<DocumentSnapshot> tmpList = tmp.documents;
    for (var tmpItem in tmpList) {
      DocumentSnapshot user = await USERS.document(tmpItem.documentID).get();
      User tmpUser = User.fromDocument(user);
      allUsers.add(tmpUser);
    }
    return allUsers;
  }

  void initState(){
    super.initState();
    this._fetchUsersFriendship();
  }

  Widget _childContent(User item){
    print("luigi");
    return Card(
      margin: EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
          bottom: 20.0
      ),
      child: Column(
        children: <Widget>[
          AvatarHeader(item.username, "", item.photoURL, Container(), item.id),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, widget.type == "userFollowers" ? "followers" : "followings"),
        body: Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        this._usersList == null ? circularProgress() : FutureBuilder(
                            future: this._getUserFriendship(this._usersList),
                            builder: (BuildContext context,snapshot) {
                              if(snapshot.hasData && snapshot.connectionState == ConnectionState.done)
                              {
                                print("ok");
                                return ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  var item = snapshot.data[index];
                                  return _childContent(item);
                                },
                              );
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            }
                        )]),
                ),
              ],
            )));
  }
}
