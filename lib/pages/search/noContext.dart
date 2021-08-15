import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoContextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset('assets/lens.png', height: 420.0),
          ],
        ),
      ),
    );
  }
}
