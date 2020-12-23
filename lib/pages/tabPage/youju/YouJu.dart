import 'package:editor_2020_9/pages/tabPage/youju/robot_value/robot_value_page.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';

class YouJuPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _YouJuState();
  }
}

class _YouJuState extends State<YouJuPage> with SingleTickerProviderStateMixin{
  TabController mController;
  int _selectIndex = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    mController = TabController(
      length: 2,
      initialIndex:  0,
      vsync: this
    );
  }

  //导航栏
  AppBar configAppBar(String title, BuildContext context) {
    return AppBar(
      leading: Text(''),
      elevation: 0, 
      actions: [
        Container(
          width: Global.ksWidth,
          child: Stack(
            children: [ 
              Center(
                child: _tabbarWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //顶部tabbar
  TabBar _tabbarWidget() {
    return TabBar(
      isScrollable: true,
      controller: mController,
      labelColor: Color(0xFF131313),
      unselectedLabelColor: Color(0xFFA5A5A5),
      indicatorWeight: 3,
      indicatorColor: Color(0xFF131313),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        Tab(
          text: '任务大厅',
        ),
        Tab(
          text: '价值排行榜',
        ),
      ],
      onTap: (e){
        setState(() {
          _selectIndex = e;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: configAppBar('title', context),
          body: TabBarView(controller: mController, children: [
            Center(child: Text('1'),),
            RobotValuePage(),
          ]),
        ));
  }
}