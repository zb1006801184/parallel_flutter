import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///问题模板页面
class QuestionTemplate extends StatefulWidget {
  @override
  _QuestionTemplateState createState() => _QuestionTemplateState();
}

class _QuestionTemplateState extends State<QuestionTemplate> {
  @override
  Widget build(BuildContext context) {
    bool isClick = false;
    int _itemCount = 10;
    return Scaffold(
      backgroundColor: GlobalColors.backColor(),
      appBar: CommonWidgets.titleBar(context, '问题模板',
          showIcon: true, moreAssets: 'assets/images/icon_search.png'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 13, left: 20, bottom: 7),
            child: Text(
              '问题分类：',
              style: TextStyle(color: GlobalColors.text9B9B9B()),
            ),
          ),
          Container(
            height: 30,
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 17),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // for(int i = 0;i<=10; i++){
                // }
                FlatButton(
                    splashColor: Colors.grey,
                    textColor: isClick
                        ? GlobalColors.whiteColor()
                        : GlobalColors.textA2a2a2(),
                    color: isClick
                        ? GlobalColors.login849FDB()
                        : GlobalColors.buttonF7f7f7(),
                    child: Text("互联网"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    onPressed: () {
                      if (!isClick) {
                        setState(() {});
                        isClick = !isClick;
                      }
                    }),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemCount: _itemCount,
                //列表项构造器
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading:
                        Image.asset("assets/images/icon_question_mark.png"),
                    title: new Text("机器人设置"),
                    trailing: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                            "assets/images/icon_alread_yowned.png")),
                    onTap: () {},
                  );
                },
                //分割器构造器
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: GlobalColors.lineFAfAfA(),
                    thickness: 12,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
