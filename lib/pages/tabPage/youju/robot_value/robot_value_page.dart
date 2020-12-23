import 'package:flutter/material.dart';

class RobotValuePage extends StatefulWidget {
  @override
  _RobotValuePageState createState() => _RobotValuePageState();
}

class _RobotValuePageState extends State<RobotValuePage>
    with SingleTickerProviderStateMixin {
  TabController mController;
  List<String> _data = ['价值', '人气', '投资', '股票', '教育', '理财', '法律'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mController =
        TabController(length: _data.length, initialIndex: 0, vsync: this);
        
  }

  List<Widget> _tabs() {
    List<Widget> result = [];
    for (var item in _data) {
      result.add(_titleItemWidget(title: item));
    }

    return result;
  }

  Widget _titleItemWidget({String title = ''}) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      height: 44,
      child: Text(title),
    );
  }

  List<Widget> _listViews() {
    List<Widget> result = [];
    for (var item in _data) {
      result.add(_listViewWidget());
    }
    return result;
  }

  Widget _listViewWidget() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            height: 44,
            color: Colors.white,
            child: Center(
              child: Text('$index'),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _data.length,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 48,
            elevation: 0,
            bottom: TabBar(
              isScrollable: true,
              labelColor: Color(0xFF131313),
              unselectedLabelColor: Color(0xFFA5A5A5),
              indicatorColor: Color(0xFFFF707070),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
              controller: mController,
              indicatorWeight: 4,
              // physics: ScrollPhysics(),
              tabs: _tabs(),
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          body: TabBarView(controller: mController, children: _listViews()),
        ));
  }
}
