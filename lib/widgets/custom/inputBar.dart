import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/utils/global.dart';
import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/widgets/custom/avatarHeader.dart';
import 'package:lumiere/widgets/custom/customButton.dart';

class InputBar extends StatelessWidget {

  final String placeHolder;
  final double padding;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final Color iconColor;
  final double fontSize;
  final dynamic handleChange;
  final TextEditingController inputController = TextEditingController();
  

  InputBar(
      { this.placeHolder = 'Search...',
        this.icon = Icons.search,
        this.iconColor = Colors.black,
        this.fontSize = 20.0,
        this.textColor = Colors.black,
        this.backgroundColor = Colors.white,
        this.padding = 20.0,
        this.handleChange,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(padding),
      child: TextFormField(
        controller: inputController,
        onFieldSubmitted: this.handleChange,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: this.fontSize),
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                this.icon,
                color: this.iconColor,
              ), // icon is 48px widget.
            ),
            hintText: this.placeHolder,
            hintStyle: TextStyle(fontSize: this.fontSize)),
      ),
    );
  }
}