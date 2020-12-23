import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/pages/login/login_code.dart';
import 'package:editor_2020_9/utils/data_name_unitls.dart';
import 'package:editor_2020_9/utils/public_tool.dart';
import 'package:editor_2020_9/utils/sp_util.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: FlatButton(
            splashColor: Colors.grey,
            textColor: GlobalColors.whiteColor(),
            color: GlobalColors.login849FDB(),
            highlightColor: GlobalColors.login849FDB(),
            child: Text("退出登录"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onPressed: () async{
              await PublicTool.removeInfo();
              ///销毁所有页面并跳转到登录页面
              Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(builder: (context) => LoginCodePage()),
                (Route<dynamic> route) => false,
              );
              ToastView(
                title: "退出登录成功！",
              ).showMessage();
            }),
      ),
    );
  }
}
