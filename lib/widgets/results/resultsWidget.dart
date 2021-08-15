import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../loader/loading.dart';

class ResultsWidget extends StatefulWidget {

  final Future<QuerySnapshot> results;
  final dynamic childWidget;

  ResultsWidget(this.results, this.childWidget, {Key key}) : super(key: key);

  @override
  _ResultsWidgetState createState() => _ResultsWidgetState();
}

class _ResultsWidgetState extends State<ResultsWidget>{

  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.results,
        builder: (context, snapshot) {
          if(!(snapshot.hasData && snapshot.connectionState == ConnectionState.done)){
            print("Still loading");
            return circularProgress();
          }
          return widget.childWidget(snapshot);
        });
  }
}
