import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:lumiere/utils/classes/User.dart';

// ignore: non_constant_identifier_names
final AUTH = FirebaseAuth.instance;
// ignore: non_constant_identifier_names
final STORAGE = FirebaseStorage.instance.ref();
// ignore: non_constant_identifier_names
final USERS = Firestore.instance.collection('users');
// ignore: non_constant_identifier_names
final POST = Firestore.instance.collection('posts');
// ignore: non_constant_identifier_names
final FOLLOWERS = Firestore.instance.collection('followers');
// ignore: non_constant_identifier_names
final FOLLOWINGS = Firestore.instance.collection('following');
// ignore: non_constant_identifier_names
final FEED = Firestore.instance.collection('feed');
// ignore: non_constant_identifier_names
final COMMENTS = Firestore.instance.collection('comments');
// ignore: non_constant_identifier_names
User CURRENTUSER;
// ignore: non_constant_identifier_names