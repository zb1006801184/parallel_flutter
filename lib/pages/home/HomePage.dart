import 'package:editor_2020_9/constants/globalColor.dart';
import 'package:editor_2020_9/pages/tabPage/center/center.dart';
import 'package:editor_2020_9/pages/tabPage/editor/_editor.dart';
import 'package:editor_2020_9/pages/tabPage/wo/Me.dart';
import 'package:editor_2020_9/pages/tabPage/youju/youju.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:flutter/material.dart';
import '../tabPage/home/home_robot_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

Widget _bottomBarItem(String icon) {
  return Image.asset(
    icon,
    width: 20,
    height: 20,
    fit: BoxFit.cover,
  );
}

class _HomeState extends State<HomePage> {
  String pageName = "example.HomePage";

  final List<BottomNavigationBarItem> tabbarList = [
    BottomNavigationBarItem(
      icon: _bottomBarItem("assets/images/tab_chat_normal.png"),
      activeIcon: _bottomBarItem("assets/images/tab_chat_focus.png"),
      title: Text("首页"),
    ),
    BottomNavigationBarItem(
      icon: _bottomBarItem("assets/images/tab_email_normal.png"),
      activeIcon: _bottomBarItem("assets/images/tab_email_focus.png"),
      title: Text("沟通"),
    ),
    BottomNavigationBarItem(
      icon: Image.asset("assets/images/tab_center.png"),
      activeIcon: Image.asset("assets/images/tab_center.png"),
      title: Text(""),
    ),
    BottomNavigationBarItem(
      icon: _bottomBarItem("assets/images/tab_edit_normal.png"),
      activeIcon: _bottomBarItem("assets/images/tab_edit_focus.png"),
      title: Text("小编"),
    ),
    BottomNavigationBarItem(
      icon: _bottomBarItem("assets/images/tab_my_normal.png"),
      activeIcon: _bottomBarItem("assets/images/tab_my_focus.png"),
      title: Text("我的"),
    ),
  ];
  final List<Widget> vcList = [
    // ZhengShiPage(),
    HomeRobotPage(),
    YouJuPage(),
    CenterPage(),
    Editor(),
    WoPage()
  ];

  int curIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _setPageIndex(int index) {

    if (Global.loginState == false ) {
      Navigator.of(context).pushNamed('/LoginCodePage');
      return;
    }
    if (index == 2) {
      Navigator.of(context).pushNamed('/AddContentPage');
      return;
    }
    setState(() {
      this.curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _setPageIndex(2);
        },
        child: Icon(Icons.add),
        hoverColor: GlobalColors.themeColor(),
        backgroundColor: GlobalColors.themeColor(),
      ),
      floatingActionButtonAnimator: ScalingAnimation(),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 0, 15),
      bottomNavigationBar: BottomNavigationBar(
        items: tabbarList,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _setPageIndex(index);
        },
        currentIndex: curIndex,
        selectedItemColor: GlobalColors.themeColor(),
        unselectedItemColor: GlobalColors.grayColor(),
      ),
      body: IndexedStack(
        index: curIndex,
        children: vcList,
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class ScalingAnimation extends FloatingActionButtonAnimator {
  double _x;
  double _y;

  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    _x = begin.dx + (end.dx - begin.dx) * progress;
    _y = begin.dy + (end.dy - begin.dy) * progress;
    return Offset(_x, _y);
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}
