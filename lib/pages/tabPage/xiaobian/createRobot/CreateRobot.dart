import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';

class CreateRobotPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CreateRobotState();
  }
}

class _CreateRobotState extends State<CreateRobotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backColor(),
      appBar: CommonWidgets.titleBar(context, '创建机器人'),
      body: Text('这是内容'),
    );
  }
}
