import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lumiere/widgets/custom/avatarHeader.dart';

class CommentWidget extends StatefulWidget{

  final String username;
  final Timestamp timestamp;
  final String avatarUrl;
  final String text;
  final String id;
  final String userId;

  CommentWidget(this.username, this.timestamp, this.avatarUrl, this.text, this.id, this.userId);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();

}

class _CommentWidgetState extends State<CommentWidget>{


  Widget _childContent(){
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(widget.timestamp.microsecondsSinceEpoch);
    DateTime now = DateTime.now();
    int difference = now.difference(date).inHours;
    String timestamp = difference.toString() + " hours ago";
    return Card(
      margin: EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
          bottom: 20.0
      ),
      child: Column(
        children: <Widget>[
          AvatarHeader(widget.username, timestamp, widget.avatarUrl, Container(), widget.userId),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: 20.0,
                  top: 0.0,
                  left: 80.0
              ),
              child: Container(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16),
                  )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return this._childContent();
  }

}