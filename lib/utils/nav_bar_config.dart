import 'package:editor_2020_9/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:editor_2020_9/utils/them_util.dart';

class NavBarConfig {
  //会话导航栏
  static AppBar configConverseAppBar(
    String title,
    BuildContext context, {
    List<Widget> rightWidget,
    List<Widget> leftWidget,
  }) {
    title = title ?? '';
    rightWidget = rightWidget ?? [];
    leftWidget = leftWidget ?? [];
    //中间按钮
    Widget _centerWidget() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, color: Color(0xFF4A4A4A)),
        ),
      ],);
    }

    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: ThemUntil().widgetColor(context), fontSize: 18),
      ),
      actions: [
        Container(
          width: Global.ksWidth,
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (leftWidget != null)
                Expanded(
                    flex: 1,
                    child: Row(
                      children: leftWidget,
                    )),
              Expanded(flex: 1, child: _centerWidget()),
              if (rightWidget != null)
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: rightWidget,
                    )),
            ],
          ),
        )
      ],
      backgroundColor: ThemUntil().mainColor(context),
      elevation: 0, //阴影辐射范围
      brightness: ThemUntil().stateBarColor(context),
    );
  }

  //左侧单个按钮
  static Widget leftButton({Function backAction}) {
    return GestureDetector(child: Container(
      padding: EdgeInsets.only(left: 20,right: 20,bottom: 2),
      child: Image.asset(
        'assets/images/nav_btn_selected.png',
        width: 20,
        height: 20,
        fit: BoxFit.cover,
      ),
    ),
    onTap: backAction,
    );
  }
  //左侧俩个按钮

  //右侧单个按钮

  //右侧俩个按钮
  static List<Widget> rightButtons({Function rightAction1,Function rightAction2,}) {
    return [
      GestureDetector(child: Container(
      padding: EdgeInsets.only(left: 16,right: 8,bottom: 2),
      child: Image.asset(
        'assets/images/nav_btn_selected.png',
        width: 17,
        height: 17,
        fit: BoxFit.cover,
      ),
    ),
    onTap: rightAction1,
    ),
    InkWell(child: Container(
      padding: EdgeInsets.only(left: 8,right: 16,bottom: 2),
      child: Image.asset(
        'assets/images/nav_btn_selected.png',
        width: 17,
        height: 17,
        fit: BoxFit.cover,
      ),
    ),
    onTap: rightAction2,
    )
    ];
  }

}
