import 'package:cloud_firestore/cloud_firestore.dart';

class PostObject {
  final String id;
  final String username;
  final Timestamp timestamp;
  final String avatarUrl;
  final String mediaUrl;
  final String description;
  List<dynamic> likes;
  final int comments;
  final String userId;
  final String mood;
  final String rating;

  PostObject(
      {this.id,
      this.username,
      this.timestamp,
      this.avatarUrl,
      this.mediaUrl,
      this.description,
      this.likes,
      this.comments,
      this.userId,
      this.mood,
      this.rating});

  factory PostObject.fromDocument(doc) {
    return PostObject(
        id: doc['id'],
        username: doc['username'],
        timestamp: doc['timestamp'],
        avatarUrl: doc['avatarUrl'],
        mediaUrl: doc['mediaUrl'],
        description: doc['description'],
        userId: doc['userId'],
        mood: doc['mood'],
        rating: doc['rating'],
        likes: doc["likes"],
        comments: doc['comments']);
  }
}
