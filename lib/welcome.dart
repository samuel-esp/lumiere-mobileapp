import 'package:flutter/material.dart';

import 'package:lumiere/pages/session/logIn.dart';
import 'package:lumiere/pages/session/signUp.dart';
import 'package:lumiere/utils/functions.dart';
import 'package:lumiere/widgets/custom/customButton.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Image.asset('assets/popcorn.png', height: 380.0)),
          Container(
            padding: EdgeInsets.only(top: 40.0, left: 60.0, right: 60.0),
            child: CustomButton(
                "Login",
                Colors.white,
                Color.fromRGBO(230, 51, 51, 1),
                Colors.black,
                () => changePage(context, LogIn()),
                EdgeInsets.fromLTRB(80.0, 7.0, 80.0, 7.0)),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, left: 60.0, right: 60.0),
            child: CustomButton(
                "Sign Up",
                Color.fromRGBO(230, 51, 51, 1),
                Color.fromRGBO(230, 51, 51, 1),
                Colors.white,
                () => changePage(context, SignUp()),
                EdgeInsets.fromLTRB(80.0, 7.0, 80.0, 7.0)),
          ),
        ],
      ),
    );
  }
}
