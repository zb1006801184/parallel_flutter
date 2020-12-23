import 'package:flutter/material.dart';

class CenterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CenterState();
  }
}

class _CenterState extends State<CenterPage>{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Text("中间页面"),
      ),
    );
  }
}