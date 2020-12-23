import 'package:editor_2020_9/network/ApiService.dart';
import 'package:editor_2020_9/pages/content_library/model/contenr_industry_model.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';

class ClassifyPage extends StatefulWidget {
  Map arguments;
  ClassifyPage({Key key, this.arguments}) : super(key: key);
  @override
  _ClassifyPageState createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyPage> {
  List<ContentIndustryModel> _dataList;
  int robotId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.arguments != null) robotId = widget.arguments['robotId'];
    _request();
  }

  void _request() async {
    _dataList = await ApiService.getContnetClassWithIdRequest(1,
        robotId: '${robotId??Global.userInfoModel.selectedRobotId}');
    setState(() {});
  }

  //################actions################
  void _itemClick(ContentIndustryModel model) {
    Navigator.of(context).pop(model);
  }

  //################widgets################
  Widget _itemWidget(int index) {
    ContentIndustryModel model = _dataList[index];
    return GestureDetector(
      child: Container(
        height: 55,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                model?.typeName,
                style: TextStyle(fontSize: 17, color: Color(0xFF3E3E3E)),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        _itemClick(model);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonWidgets.titleBar(context, '选择分类'),
        backgroundColor: Colors.white,
        body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return _itemWidget(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                height: 1,
                color: Color(0xFFF2F2F2),
              );
            },
            itemCount: _dataList?.length ?? 0));
  }
}
