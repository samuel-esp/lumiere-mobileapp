import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {

  final String imageUrl;

  PostContent(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: double.infinity,
        height: 300,
        child: Image.network(
            this.imageUrl,
          fit: BoxFit.fitWidth,
        )
      );
  }
}