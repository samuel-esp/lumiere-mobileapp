import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final String photoURL;
  final String coverURL;
  final String bio;

  User({
    this.id,
    this.username,
    this.email,
    this.name,
    this.photoURL,
    this.coverURL,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      name: doc['name'],
      photoURL: doc['photoURL'],
      coverURL: doc['coverURL'],
      bio: doc['bio'],
    );
  }
}
