import 'package:flutter/material.dart';


class TextColumnWidget extends StatelessWidget {

  final Widget title;
  final Widget subtitle;
  final double edgeLeft;
  final double edgeRight;
  final double edgeBottom;
  final double edgeTop;

  TextColumnWidget(this.title, [this.subtitle, this.edgeLeft=10.0, this.edgeRight = 0.0, this.edgeTop = 0.0, this.edgeBottom = 0.0]);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left: this.edgeLeft,
            right: this.edgeRight,
            top: this.edgeTop,
            bottom: this.edgeBottom
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            this.title,
            this.subtitle != null ? this.subtitle : Container()
          ],
        ),
      ),
    );
  }
}