import 'package:flutter/material.dart';

AppBar header(context, String pageName) {
// try
  return AppBar(
    title: Text(pageName,
        style: TextStyle(
            fontFamily: "Baloo", fontSize: 20.0, color: Colors.black)),
    centerTitle: true,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),

  );
}
