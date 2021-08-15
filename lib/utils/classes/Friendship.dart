class FriendshipObject{

  final List<dynamic> userIds;
  final String type;

  FriendshipObject({this.userIds, this.type});

  factory FriendshipObject.fromDocument(doc) {
    return FriendshipObject(
      userIds: doc['userIds'],
      type: doc['type'],
    );
  }

}