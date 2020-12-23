import 'package:editor_2020_9/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PopMenu {
  //对话框弹出菜单
  static void showPopMenu(BuildContext context, {Function callBack}) {
    List<PopupMenuEntry<String>> items = new List();
    List<String> dataList = ['分享链接', '扫一扫', '速配', '未知问题'];
    List imagesList = [
      'assets/images/fenxiang.png',
      'assets/images/saoyisao.png',
      'assets/images/supeei.png',
      'assets/images/wentifankui.png',
    ];

    for (var i = 0; i < dataList.length; i++) {
      PopupMenuItem<String> p = PopupMenuItem(
        child: PopMenu._itemWidget(
            isShowLine: i == 3 ? false : true,
            title: dataList[i],
            imagesUrl: imagesList[i]),
        value: '${i}',
      );
      items.add(p);
    }

    Offset tapPos =
        Offset(Global.ksWidth, Global.ksToolbarHeight + Global.ksStateHeight);
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromLTRB(tapPos.dx, tapPos.dy,
        overlay.size.width - tapPos.dx, overlay.size.height - tapPos.dy);
    showMenu(
      context: context,
      position: position,
      items: items,
      color: Color(0xFF4C4C4C),
    ).then((value) {
      if (value != null) {
        callBack(value);
      }
    });
  }

  static Widget _itemWidget(
      {bool isShowLine = true, String imagesUrl, String title}) {
    return Container(
      height: 50,
      width: 130,
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Image.asset(
                imagesUrl,
                height: 17,
                width: 17,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          )),
          if (isShowLine == true)
            Container(
              height: 1,
              color: Colors.white.withAlpha(46),
            ),
        ],
      ),
    );
  }
}
