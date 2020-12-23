import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/pages/content_library/content_library.dart';
import 'package:editor_2020_9/utils/navigator_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///小编页面
class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  int _itemCount = 1;

  Widget _createItem(String assetsIcon, String desc) {
    return InkWell(
      onTap: () {
        if (desc.contains("问答对话")) {
          NavigatorUtil.push(context, ContentLibrary());
        }
      },
      child: Container(
        child: Column(
          children: [
            Image.asset(assetsIcon),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                desc,
                style:
                    TextStyle(color: GlobalColors.text4a4a4a(), fontSize: 17),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backColor(),
      body: Column(
        children: [
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50),
              child: Text(
                "小编",
                style:
                    TextStyle(fontSize: 20, color: GlobalColors.text4a4a4a()),
              )),
          Container(
            height: 208,
            child: new Swiper(
              key: UniqueKey(),
              itemBuilder: (BuildContext context, int index) {
                return new Image.asset(
                  "assets/images/img_banner.png",
                  fit: BoxFit.fill,
                );
              },
              // loop: false,//是否无限轮播
              autoplay: true,
              itemCount: _itemCount,
              itemWidth: 300.0,
              // layout: SwiperLayout.STACK,
            ),
          ),
          Expanded(
            child: GridView(
                padding: EdgeInsets.only(top: 2),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  //横轴三个子widget
                  childAspectRatio: 1.0,
                ),
                children: <Widget>[
                  _createItem('assets/images/icon_dialogue.png', '问答对话'),
                  _createItem('assets/images/icon_publish_task.png', '发布任务'),
                  _createItem(
                      'assets/images/icon_put_questions_to.png', '有奖提问'),
                  _createItem('assets/images/icon_form.png', '设计表单'),
                  _createItem('assets/images/icon_h5.png', 'H5'),
                  _createItem('assets/images/icon_eda.png', 'EDA'),
                  _createItem('assets/images/icio_cad.png', 'CAD'),
                  _createItem('assets/images/icon_bim.png', 'Bim'),
                ]),
          ),
        ],
      ),
    );
  }
}
