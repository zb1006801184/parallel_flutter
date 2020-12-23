import 'package:editor_2020_9/app.dart';
import 'package:editor_2020_9/config/Cache.dart';
import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/pages/tabPage/xiaobian/MyRobotEntity.dart';
import 'package:editor_2020_9/pages/tabPage/xiaobian/createRobot/CreateRobot.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';

class XiaoBianPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _XiaoBianState();
  }
}

Color _appBarTextColor() {
  return Color.fromARGB(255, 74, 74, 74);
}

Color _titleColor() {
  return Color.fromARGB(255, 65, 65, 65);
}

Color _itemTextColor() {
  return Color.fromARGB(255, 167, 167, 167);
}

Widget _appBar() {
  return new AppBar(
    shadowColor: Color.fromARGB(50, 253, 253, 253),
    elevation: 5,
    title: Text(
      "小编",
      style: TextStyle(fontSize: 16, color: _appBarTextColor()),
    ),
    centerTitle: true,
    backgroundColor: GlobalColors.backColor(),
    toolbarHeight: 45,
  );
}

///返回我的机器人和场景机器人模板视图
Widget _itemBoxView(MyRobotEntity item) {
  bool netIcon = true;
  if (item.iconAssets != null) {
    netIcon = false;
  }
  String icon = item.iconUrl ?? item.iconAssets;
  CircleAvatar _icon() {
    if (netIcon) {
      return CircleAvatar(
        backgroundImage: NetworkImage(icon),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        radius: 100.0,
      );
    } else {
      return CircleAvatar(
        backgroundImage: AssetImage(icon),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        radius: 100.0,
      );
    }
  }

  Color _iconBgColor =
      netIcon ? Color.fromARGB(255, 224, 231, 246) : Color.fromARGB(0, 0, 0, 0);
  Color _lockColor =
      item.lock && (!Cache.isPersonCertified || !Cache.isCompanyCertified)
          ? Color.fromARGB(255, 188, 188, 188)
          : Colors.transparent;

  return InkWell(
    onTap: () => _clickedRobotItem(item),
    child: Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: const Alignment(0.0, 0.0), children: [
                Container(
                  width: 65,
                  height: 65,
                  child: CircleAvatar(
                    backgroundColor: _iconBgColor,
                    radius: 100.0,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  child: _icon(),
                )
              ]),
              Container(
                child: Text(item.name,
                    style: TextStyle(fontSize: 15, color: _itemTextColor())),
                margin: EdgeInsets.only(top: 15),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Image.asset(
              'assets/images/icon_robot_lock.png',
              width: 15,
              height: 19,
              fit: BoxFit.cover,
              color: _lockColor,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: GlobalColors.lineColor(),
                offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                blurRadius: 8.0, //阴影模糊程度
                spreadRadius: 2.0 //阴影扩散程度
                )
          ]),
    ),
  );
}

///点击了机器人某一项
void _clickedRobotItem(MyRobotEntity item) {
  if (item.createButton) {
    Navigator.of(_context).pushNamed('/robot_createMyRobot');
  } else {
    //todo 跳转到机器人相应页面
  }
}

List<MyRobotEntity> _myRobotData = List(); //已创建的机器人数据
List<MyRobotEntity> _templateData = List(); //场景机器人数据
BuildContext _context;

class _XiaoBianState extends State<XiaoBianPage> {
  @override
  void initState() {
    super.initState();
    MyRobotEntity addData = MyRobotEntity('创建机器人',
        iconAssets: 'assets/images/icon_create_robot.png', createButton: true);
    _myRobotData.add(addData);
    _refreshView();
    _requireMyRobots();
    _requireTemplateRobots();
  }

  void _refreshView() {
    setState(() {});
  }

  ///请求我创建的机器人
  void _requireMyRobots() async {
    Future.delayed(Duration(seconds: 10), () {
      MyRobotEntity addData = MyRobotEntity('机器人',
          iconUrl:
              'https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1602297215&di=8f03a53223b4ea070166b65fa6eea5b4&src=http://a4.att.hudong.com/27/67/01300000921826141299672233506.jpg');
      _myRobotData.add(addData);
      _refreshView();
    });
  }

  ///请求我创建的机器人
  void _requireTemplateRobots() async {
    Future.delayed(Duration(seconds: 10), () {
      for (int i = 0; i < 6; i++) {
        MyRobotEntity addData = MyRobotEntity('场景机器人',
            lock: true,
            iconUrl:
                'https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1602297215&di=8f03a53223b4ea070166b65fa6eea5b4&src=http://a4.att.hudong.com/27/67/01300000921826141299672233506.jpg');
        _templateData.add(addData);
      }
      _refreshView();
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: CommonWidgets.titleBar(context, '小编', showIcon: false),
      backgroundColor: GlobalColors.backColor(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              child: Text(
                '我的机器人',
                style: TextStyle(color: _titleColor(), fontSize: 16),
              ),
              padding: EdgeInsets.fromLTRB(13, 15, 0, 2),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(13),
            sliver: new SliverGrid(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 13.0,
                crossAxisSpacing: 13.0,
                childAspectRatio: 0.75,
              ),
              delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  //创建子widget
                  return _itemBoxView(_myRobotData.elementAt(index));
                },
                childCount: _myRobotData.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: GlobalColors.lineColor(),
              height: 8,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Text(
                '场景机器人模版',
                style: TextStyle(color: _titleColor(), fontSize: 16),
              ),
              padding: EdgeInsets.fromLTRB(13, 15, 0, 2),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(13),
            sliver: new SliverGrid(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 13.0,
                crossAxisSpacing: 13.0,
                childAspectRatio: 0.75,
              ),
              delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  //创建子widget
                  return _itemBoxView(_templateData.elementAt(index));
                },
                childCount: _templateData.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
