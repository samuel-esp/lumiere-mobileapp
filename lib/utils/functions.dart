import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void changePage(BuildContext context, Widget page, {bool check = false}){
  print("check $page");
  if(check){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  else{
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

void goBack(BuildContext context){
  Navigator.of(context).pop();
}