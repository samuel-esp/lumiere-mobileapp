import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lumiere/utils/global.dart';
import 'package:lumiere/pages/profile/profile.dart';
import 'package:lumiere/pages/search/searchHistory.dart';
import 'package:lumiere/pages/posts/addPost.dart';
import 'package:lumiere/pages/posts/feed.dart';
import 'package:lumiere/pages/notifications/notifications.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  PageController pageController;
  int pageIndex = 0;

  void initState() {
    super.initState();
    pageController = PageController();
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Feed(),
          Notifications(),
          AddPost(),
          SearchTab(),
          ProfilePage(CURRENTUSER.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle))
        ],
      ),
    );
  }
}
