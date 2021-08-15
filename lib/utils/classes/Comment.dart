import 'package:cloud_firestore/cloud_firestore.dart';

class CommentObject {

  final String id;
  final String userId;
  final String username;
  final String avatarUrl;
  final String text;
  final Timestamp timestamp;

  CommentObject({this.id, this.username, this.timestamp, this.avatarUrl, this.text, this.userId});

  factory CommentObject.fromDocument(doc) {
    return CommentObject(
        id: doc['id'],
        username: doc['username'],
        userId: doc['userId'],
        timestamp: doc['timestamp'],
        avatarUrl: doc['avatarUrl'],
        text: doc['text'],
    );
  }
}
