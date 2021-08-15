import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChildWidget extends StatefulWidget {

  final List<dynamic> snapshot;
  final dynamic childWidget;

  ChildWidget(this.snapshot, this.childWidget, {Key key}) : super(key: key);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: widget.snapshot.length,
      itemBuilder: (context, index) {
        var item = widget.snapshot[index];
        return widget.childWidget(item);
      },
    );
  }
}
