import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumiere/utils/global.dart';

import 'package:lumiere/pages/search/noContext.dart';
import 'package:lumiere/pages/search/results.dart';

import 'package:lumiere/widgets/custom/inputBar.dart';


class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  Future<QuerySnapshot> _results;

  void _onStringChange(Future<QuerySnapshot> val) {
    setState(() {
      _results = val;
    });
  }

  void _search(String query) {
    /*
    * TODO check query
    * */
    Future<QuerySnapshot> users =
        USERS.where("username", isGreaterThanOrEqualTo: query).getDocuments();
    print("Looking for $query");
    this._onStringChange(users);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          InputBar(
            handleChange: this._search,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 25),
                child: Text("#Recent search",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)),
              ),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: GestureDetector(
                  onTap: () {
                    setState((){
                      this._results = null;
                    });
                  },
                  child: Text("Clear all",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0)),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
          ),
          this._results == null ? NoContextWidget() : SearchResultsWidget(this._results),
        ],
      ),
    ));
  }
}
