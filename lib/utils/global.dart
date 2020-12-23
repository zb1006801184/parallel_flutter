import 'dart:convert';
import 'dart:ui';
import 'package:editor_2020_9/pages/login/model/login_info_model.dart';
import 'package:editor_2020_9/pages/login/model/user_info_model.dart';
import 'package:editor_2020_9/utils/sp_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data_name_unitls.dart';

class Global {
  //全局用户信息
  static LoginInfoModel tokenModel;
  static UserInfoModel userInfoModel;
  static bool loginState = false;
  static int industryPage; //内容库行业分类总页数
  static int questionPage; //内容库问题总页数

  static Future init() async {
    loginState = SpUtil.getBool(DataName.LOGINSTATE);
    if (loginState == true) {
      print("已登录");
    } else {
      print("未登录");
    }
    // var _userInfoModel = SpUtil.getString(DataName.PERSONINFO);
    // if (_userInfoModel != null) {
    //   try {
    //     userModel = UserInfoModel.fromJson(jsonDecode(_userInfoModel));
    //   } catch (e) {
    //     print(e);
    //   }
    // }
    var _robotId = SpUtil.getInt(DataName.USERROBOTID);
    if (_robotId != null && _robotId > 0) {
      try {
        userInfoModel = UserInfoModel(selectedRobotId: _robotId);
      } catch (e) {
        print(e);
      }
    }

    var _token = SpUtil.getString(DataName.TOKENINFO);
    if (_token != null) {
      try {
        tokenModel = LoginInfoModel(accessToken: _token);
      } catch (e) {
        print(e);
      }
    }
  }

//设备宽高
  static double ksWidth = _width;
  static double ksHeight = _height;

//导航栏的高度
  static double ksToolbarHeight = kToolbarHeight;

//状态栏高度
  static double ksStateHeight = MediaQueryData.fromWindow(window).padding.top;
  static double ksBottomBar = kBottomNavigationBarHeight;

  static double get _width {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    return mediaQuery.size.width;
  }

  static double get _height {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    return mediaQuery.size.height;
  }

  //大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
  // 此方法中前三位格式有 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
  static bool isMobileMatch(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }
}
