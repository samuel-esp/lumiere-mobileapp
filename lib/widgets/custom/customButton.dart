import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double fontSize;
  final Color borderColor;
  final double borderRadius;
  final Function handlePress;
  final EdgeInsets paddingButton;

  CustomButton(this.buttonText, this.buttonColor, this.borderColor, this.textColor, this.handlePress, this.paddingButton, [this.fontSize = 20, this.borderRadius = 18 ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.0),
      child: RaisedButton(
        padding: this.paddingButton,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(this.borderRadius),
            side: BorderSide(color: this.borderColor)),
        onPressed: () => handlePress(),
        focusElevation: 3.0,
        color: this.buttonColor,
        child: Text(this.buttonText, style: TextStyle(fontSize: this.fontSize, color: this.textColor)),
      ),
    );
  }
}
