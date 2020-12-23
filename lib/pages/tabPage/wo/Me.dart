import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/pages/tabPage/wo/_setting.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/CreateModelHome.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/RobotModelEntity.dart';
import 'package:editor_2020_9/utils/navigator_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WoState();
  }
}

class _WoState extends State<WoPage> {
  @override
  Widget build(BuildContext context) {
    String _masterName = "Jason"; //主人名称
    String _robotName = "金融科技"; //机器人名称
    String _followNum = "118"; //关注人数
    String _fansNum = "118"; //粉丝人数
    String _balance = "4432"; //余额
    int _robotValue = 22; //机器人价值
    return Scaffold(
      backgroundColor: GlobalColors.backColor(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, //靠左
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 55, left: 20),
                  width: 72,
                  height: 72,
                  child: CircleAvatar(
                    radius: 50, //图片圆角
                    backgroundImage: NetworkImage(
                        "http://diting-parallel-man.pingxingren.com/sp_1605598000541.png"),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 60, bottom: 5, left: 20, right: 20),
                      child: Text(
                        "主人名称:" + " $_masterName",
                        style: TextStyle(
                            color: GlobalColors.text2b2b2b(),
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 10),
                      child: Text(
                        "机器人名称:" + " $_robotName",
                        style: TextStyle(
                            color: GlobalColors.text9B9B9B(), fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 112),
              child: Row(
                children: [
                  Image.asset("assets/images/icon_follow.png"),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: " 关注:",
                        style: TextStyle(
                            color: GlobalColors.text9B9B9B(), fontSize: 15),
                      ),
                      TextSpan(
                        text: "$_followNum    ",
                        style: TextStyle(
                            color: GlobalColors.text000000(), fontSize: 15),
                      ),
                    ]),
                  ),
                  Image.asset("assets/images/icon_fans.png"),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: " 粉丝:",
                        style: TextStyle(
                            color: GlobalColors.text9B9B9B(), fontSize: 15),
                      ),
                      TextSpan(
                        text: "$_fansNum",
                        style: TextStyle(
                            color: GlobalColors.text000000(), fontSize: 15),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: GlobalColors.lineColor(),
                    offset: Offset(1.0, 1.0), //阴影xy轴偏移量
                    blurRadius: 11.0, //阴影模糊程度
                    spreadRadius: 0.1 //阴影扩散程度
                    )
              ]),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text("$_robotValue" + "W",
                                style: TextStyle(
                                    color: GlobalColors.text000000(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                          ),
                          Text("机器人价值",
                              style: TextStyle(
                                  color: GlobalColors.text6c6c6c(),
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: VerticalDivider(
                        color: GlobalColors.lineD5d5d5(),
                        width: 1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(" $_balance",
                                style: TextStyle(
                                    color: GlobalColors.text000000(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                          ),
                          Text("我的余额",
                              style: TextStyle(
                                  color: GlobalColors.text6c6c6c(),
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Image.asset("assets/images/icon_robot.png"),
                    title: new Text("机器人设置"),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _dividerPadding(),
                  ListTile(
                    leading:
                        Image.asset("assets/images/icon_generalfunctions.png"),
                    title: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //左右对齐
                            children: [
                              new Text("通用功能"),
                              Expanded(
                                child: new Text(
                                  "  设置机器人可使用的功能",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: GlobalColors.text9B9B9B()),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _dividerPadding(),
                  ListTile(
                    leading: Image.asset("assets/images/icon_extension.png"),
                    title: new Text("推广机器人"),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _dividerPadding(),
                  ListTile(
                    leading: Image.asset("assets/images/icon_modeling.png"),
                    title: new Text("建模"),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      _createModel(context);
                    },
                  ),
                  _dividerPadding(),
                  ListTile(
                    leading: Image.asset("assets/images/icon_task.png"),
                    title: new Text("领取的任务"),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _dividerPadding(),
                  ListTile(
                    leading: Image.asset("assets/images/icon_collection.png"),
                    title: new Text("我的收藏"),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _dividerPadding(),
                  ListTile(
                    leading:
                        Image.asset("assets/images/icon_customer_service.png"),
                    title: new Text("在线客服"),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _dividerPadding(),
                  ListTile(
                    leading: Image.asset("assets/images/icon_setup.png"),
                    title: new Text("设置"),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      NavigatorUtil.push(context, SettingPage());
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Divider(height: 1),
                  )
                ],
              ),
            ),
          ]),
    );
  }

  ///分割线
  Padding _dividerPadding() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Divider(height: 1),
    );
  }

  void _createModel(BuildContext context) {
    List<RobotModelEntity> robots = List();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateModelHome(
              parentRobot: robots,
            )));
  }
}
