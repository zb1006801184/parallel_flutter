import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//页面跳转工具类
class NavigatorUtil {
  ///跳转指定页面
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  ///销毁当前页面
  static pop(BuildContext context) {
    Navigator.pop(context);
  }
}
