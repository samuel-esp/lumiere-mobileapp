import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationObject{

  final String ownerId;
  final String type;
  final String infoText;
  final Timestamp timestamp;
  final String userIdNotification;
  final String userProfileImage;

  NotificationObject({this.ownerId, this.type, this.userProfileImage, this.infoText, this.timestamp, this.userIdNotification});

  factory NotificationObject.fromDocument(doc) {
    return NotificationObject(
      ownerId: doc['ownerId'],
      type: doc['type'],
      userProfileImage: doc['userProfileImage'],
      infoText: doc['infoText'],
      userIdNotification: doc['userId'],
      timestamp: doc['timestamp']
    );
  }
}