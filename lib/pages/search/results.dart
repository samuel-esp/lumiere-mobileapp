import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lumiere/utils/global.dart';
import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/widgets/custom/avatarHeader.dart';
import 'package:lumiere/widgets/custom/followButton.dart';
import 'package:lumiere/widgets/results/resultsWidget.dart';

class SearchResultsWidget extends StatefulWidget {

  final Future<QuerySnapshot> results;

  const SearchResultsWidget(this.results, {Key key}) : super(key: key);

  @override
  _SearchResultsWidgetState createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {


  void initState() {
    super.initState();
  }

  List<DocumentSnapshot> _getDocumentsWithUserPhotoNotNull(List<DocumentSnapshot> documents) {
    var documentsWithUserPhotoNotNull = List<DocumentSnapshot>();

    documents.forEach((doc) async {
      User user = User.fromDocument(doc);
      if (user.photoURL != null && user.id != CURRENTUSER.id) {
        documentsWithUserPhotoNotNull.add(doc);
      }
    });

    return documentsWithUserPhotoNotNull;
  }

  Future<bool> _checkIfFollowing(String currentUser, String fetchedUser) async {
    DocumentSnapshot doc = await FOLLOWINGS.document(currentUser).collection('userFollowing').document(fetchedUser).get();
    return doc.exists;
  }

  Widget _childWidget(snapshot) {

    var docsWhereUserPhotoIsNotNull =
    this._getDocumentsWithUserPhotoNotNull(snapshot.data.documents);
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: docsWhereUserPhotoIsNotNull.length,
        itemBuilder: (context, index) {
          DocumentSnapshot doc = docsWhereUserPhotoIsNotNull[index];
          User user = User.fromDocument(doc);
          Future<bool> check = this._checkIfFollowing(CURRENTUSER.id, user.id);
          return FutureBuilder(
              future: check,
              builder: (context, AsyncSnapshot snapshot) {
                if (!(snapshot.connectionState == ConnectionState.done)) {
                  //return circularProgress();
                  return Container();
                }
                bool check = snapshot.data;
                return AvatarHeader(user.username, " ", user.photoURL, FollowButton(check ? "Unfollow" : "Follow", check ? Colors.black : Color.fromRGBO(230, 51, 51, 1), check ? Colors.black : Color.fromRGBO(230, 51, 51, 1), Colors.white, check, CURRENTUSER.id, user.id), user.id);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return ResultsWidget(widget.results, this._childWidget);
  }
}
