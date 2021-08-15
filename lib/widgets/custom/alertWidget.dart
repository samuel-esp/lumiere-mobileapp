import 'package:flutter/material.dart';
import 'package:lumiere/utils/functions.dart';


class AlertWidget extends StatelessWidget {

  final String title;
  final String message;
  final String buttonText;

  AlertWidget(this.message, {this.title = "Error", this.buttonText = "Ok"});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(this.title),
      content: Text(message),
      actions: [
        FlatButton(
          child: Text(this.buttonText),
          onPressed: () {
            goBack(context);
          },
        )
      ],
    );
  }
}
