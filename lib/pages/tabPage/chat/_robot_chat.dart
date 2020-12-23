import 'package:flutter/material.dart';

class RobotChatPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RobotChatState();
  }
}

class _RobotChatState extends State<RobotChatPage>{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Text("首页"),
      ),
    );
  }
}