import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineItem{

  final String postId;
  final Timestamp timestamp;

  TimelineItem({this.postId, this.timestamp});

  factory TimelineItem.fromDocument(doc) {
    return TimelineItem(
        postId: doc['postId'],
        timestamp: doc['timestamp'],
    );
  }

}