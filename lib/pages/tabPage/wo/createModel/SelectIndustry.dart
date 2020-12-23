import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/SelectIndustryEntity.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:editor_2020_9/network/ApiService.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/ClassifyEntity.dart';
///行业分类
class SelectIndustryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectIndustryState();
  }
}

class _SelectIndustryState extends State<SelectIndustryPage> {
  @override
  void initState() {
    super.initState();
    _getClassifyList();
  }

  /// 获取分类列表
  void _getClassifyList() {
    ApiService.getClassifyList().then((data) => {_setClassifyList(data)});
  }

  /// 设置分类列表
  void _setClassifyList(classifies) {
    List<SelectIndustryEntity> classifyData = List();
    for (var classify in classifies) {
      print("获取行业分类列表-data:" + classify.toString());
      var title = classify["name"].toString();
      List<ClassifyEntity> jobs = List();
      var childResources = classify["childResources"];
      print("获取行业分类列表-childResources:" + childResources.toString());
      if(childResources!=null){
        for (var childResource in childResources) {
          print("获取行业分类列表-childResource:" + childResource["name"].toString());
          jobs.add(ClassifyEntity.fromMap(childResource));
        }
      }
      classifyData.add(SelectIndustryEntity(title, jobs));
    }
    setState(() {
      _jobs = classifyData;
    });
  }

  List<SelectIndustryEntity> _jobs = List();

  ///创建一个行业的所有职业视图组件
  Widget _createOneIndustry(int index) {
    SelectIndustryEntity item = _jobs.elementAt(index);

    if (item.jobs.length == 0) {
      return SizedBox();
    }
    List<Widget> jobsView = List();

    for (int i = 0; i < item.jobs.length; i++) {
      ClassifyEntity _job = item.jobs.elementAt(i);
      jobsView.add(Container(
        height: 28,
        color: _job.name == '添加自定义' && item.industry == '自定义'
            ? Colors.transparent
            : GlobalColors.lineF0f0f0(),
        child: OutlineButton(
          highlightedBorderColor: Colors.transparent,
          child: Text(_job.name,
              style: TextStyle(color: GlobalColors.text9B9B9B(), fontSize: 13)),
          highlightColor: Color(0xff849FDB),
          borderSide: BorderSide(
              color: _job.name == '添加自定义' && item.industry == '自定义'
                  ? GlobalColors.grayColor()
                  : GlobalColors.lineF0f0f0()),
          textColor: GlobalColors.whiteColor(),
          color: GlobalColors.whiteColor(),
          onPressed: () {
            print("被点击的行业:"+_job.toJson().toString());
            Navigator.pop(context, _job);
          },
        ),
      ));
    }

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 34,
            color: Color(0xffF5F5F5),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15),
            child: Text(item.industry,
                style:
                    TextStyle(color: GlobalColors.text989898(), fontSize: 14)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              spacing: 12,
              // 主轴(水平)方向间距
              runSpacing: 12,
              // 纵轴（垂直）方向间距
              children: jobsView,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.titleBar(context, '选择分类'),
      backgroundColor: GlobalColors.backColor(),
      body: ListView.builder(
          itemCount: _jobs.length,
          itemBuilder: (BuildContext context, int index) {
            return _createOneIndustry(index);
          }),
    );
  }
}
