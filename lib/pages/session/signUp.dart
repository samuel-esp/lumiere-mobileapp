import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:lumiere/utils/functions.dart';
import 'package:lumiere/utils/global.dart';
import 'package:lumiere/home.dart';
import 'package:lumiere/utils/classes/User.dart';
import 'package:lumiere/welcome.dart';
import 'package:lumiere/widgets/custom/alertWidget.dart';
import 'package:lumiere/widgets/custom/customButton.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String username = '';
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();

  void _signUp(String email, String password, String username) async {
    if (_formKey.currentState.validate()) {
      registerToFb(email, password, username);
    }
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
                    'Sign up',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Baloo2',
                      fontWeight: FontWeight.w700,
                      fontSize: 60.0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 40.0, 30.0, 20.0),
                  child: Text(
                    '"Il miglior modo per imparare a fare un film è farne uno."\n(Stanley Kubrick)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 50.0, 0.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: Color.fromRGBO(230, 51, 51, 1),
                            ),
                            hintText: 'Username',
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
                              val.isEmpty ? 'Enter an username' : null,
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.mail,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.only(top: 25.0),
                  child: CustomButton("Sign Up", Color.fromRGBO(230, 51, 51, 1), Color.fromRGBO(230, 51, 51, 1), Colors.white, () => this._signUp(email, password, username), EdgeInsets.fromLTRB(97.0, 8.0, 97.0, 8.0)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Text(
                    error,
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                      fontSize: 1.0,
                      color: Colors.red,
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

  Future<User> _getUser(String userID) async {
    DocumentSnapshot snapshot = await USERS.document(userID).get();

    User user = User.fromDocument(snapshot);

    return user;
  }

  void registerToFb(String email, String password, String username) {
    /** TODO Handle register **/
    AUTH
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      USERS.document(result.user.uid).setData({
        "id": result.user.uid,
        "email": email,
        "username": username,
        "name": username,
        "coverURL": "https://i.ibb.co/LPKXhJR/IMG-0042.jpg",
        "photoURL":
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
        "bio": "You can write something about you here."
      }).then((res) async {
        CURRENTUSER = await this._getUser(result.user.uid);
        changePage(context, Home());
      }).then((value) => null);
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertWidget(err.nessage);
          });
    });
  }
}
