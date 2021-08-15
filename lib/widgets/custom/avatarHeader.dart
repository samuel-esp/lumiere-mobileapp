import 'package:flutter/material.dart';
import 'package:lumiere/home.dart';
import 'package:lumiere/pages/profile/profile.dart';
import 'package:lumiere/utils/functions.dart';
import 'package:lumiere/widgets/custom/avatar.dart';
import 'package:lumiere/widgets/custom/textColumn.dart';

class AvatarHeader extends StatelessWidget {

  final String name;
  final String subtitle;
  final String avatarUrl;
  final Widget widgetSide;
  final String profileId;

  AvatarHeader(this.name, this.subtitle, this.avatarUrl, this.widgetSide, this.profileId);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: GestureDetector(
          onTap: () => changePage(context, ProfilePage(this.profileId), check: true)
          ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  AvatarWidget(this.avatarUrl),
                  Column(children: [
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 0.0,
                          top: 0.0,
                          left: 0.0,
                          right: 30
                      ),
                      child: Text(
                        this.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 2.0,
                          top: 0.0,
                          left: 0.0
                      ),
                      child: Container(
                          child: Text(
                            this.subtitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 16),
                          )),
                    )
                  ],)
                ],
              ),
              this.widgetSide
            ],
          ),
        ),
      ),
    );
  }
}
