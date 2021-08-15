import 'package:flutter/material.dart';


class AvatarWidget extends StatelessWidget {

  final String avatarUrl;
  final double edgePadding;
  final double dimensions;
  final BoxShape shape;

  AvatarWidget(this.avatarUrl, [this.edgePadding = 10.0, this.dimensions = 50.0, this.shape = BoxShape.circle]);

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: EdgeInsets.all(this.edgePadding),
        width: this.dimensions,
        height: this.dimensions,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(this.avatarUrl)
            )
        ),
      );
  }
}
