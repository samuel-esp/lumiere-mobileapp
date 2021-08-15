import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumiere/utils/functions.dart';

import 'package:lumiere/utils/global.dart';
import 'package:lumiere/home.dart';
import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/welcome.dart';
import 'package:lumiere/widgets/custom/alertWidget.dart';
import 'package:lumiere/widgets/custom/customButton.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String username = '';
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();

  void _login(String email, String password, String username) async {
    if (_formKey.currentState.validate()) {
      logInToFb(email, password, username);
    }
  }

  Future<User> getUser(String userID) async {
    DocumentSnapshot snapshot = await USERS.document(userID).get();

    User user = User.fromDocument(snapshot);

    return user;
  }

  void logInToFb(String email, String password, String username) {
    AUTH
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      CURRENTUSER = await getUser(result.user.uid);
      changePage(context, Home());
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertWidget(err.toString());
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Baloo2',
                      fontWeight: FontWeight.w700,
                      fontSize: 60.0,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 40.0, 30.0, 20.0),
                  child: Text(
                    '"L’arte del film può esistere solo e davvero attraverso un tradimento altamente organizzato della realtà."\n(François Truffaut)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 43.0),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: Color.fromRGBO(230, 51, 51, 1),
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontFamily: 'Baloo2',
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(230, 51, 51, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.redAccent[700],
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.redAccent[700],
                              ),
                            ),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                              color: Color.fromRGBO(230, 51, 51, 1),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontFamily: 'Baloo2',
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(230, 51, 51, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.redAccent[700],
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(50.0, 50.0)),
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.redAccent[700],
                              ),
                            ),
                          ),
                          validator: (val) => val.length < 6
                              ? 'Enter a password with 6+ characters long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 55.0),
                        CustomButton("Login", Color.fromRGBO(230, 51, 51, 1), Color.fromRGBO(230, 51, 51, 1), Colors.white, () => this._login(email, password, username), EdgeInsets.fromLTRB(90.0, 8.0, 90.0, 8.0)),
                        Text(
                          error,
                          style: TextStyle(
                            fontFamily: 'Baloo2',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                            fontSize: 1.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  child: IconButton(
                    padding: EdgeInsets.only(top: 30.0),
                    icon: Icon(
                      Icons.add_to_home_screen,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    onPressed: () {
                      changePage(context, Welcome());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
