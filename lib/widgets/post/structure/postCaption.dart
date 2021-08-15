import 'package:flutter/material.dart';
import 'package:lumiere/widgets/custom/textColumn.dart';

class PostCaption extends StatelessWidget {

  final String caption;
  final bool checkEntireCaption;

  PostCaption(this.caption, this.checkEntireCaption);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextColumnWidget(
                Container(
                  margin: EdgeInsets.only(
                    bottom: 2.0,
                    top: 0.0,
                  ),
                  child: Container(
                      child: !this.checkEntireCaption ? Text(
                        this.caption,
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14),
                      ) : Text(
                        this.caption,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14),
                      )
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
