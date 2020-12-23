import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/pages/home/HomePage.dart';
import 'package:editor_2020_9/pages/login/login_code.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/navigator_util.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPasswordPage extends StatefulWidget {
  @override
  _LoginPasswordPageState createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _mobileController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    bool isHide = false;
    return Scaffold(
      backgroundColor: GlobalColors.backColor(),
      body: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //靠左
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end, //靠右
              children: <Widget>[
                Text("先看看 ",
                    style: TextStyle(
                        fontSize: 18, color: GlobalColors.textC4c4c4())),
                Image.asset(
                  'assets/images/forward.png',
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 28, bottom: 5),
              child: Text(
                "欢迎来到平行人",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
            ),
            textContainer("Welcome to.ping xing ren", 0, 18),
            textContainer("手机号", 52, 16),
            TextField(
              maxLength: 11,
              controller: _mobileController,
              autofocus: true,
              style: TextStyle(
                fontSize: 18.0,
              ),
              //输入文本的样式
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "", //去除底部字数显示
                hintText: '请输入手机号',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: GlobalColors.textC1c1c1(),
                ),
              ),
              keyboardType: TextInputType.number, //弹出数字键盘
            ),
            Divider(height: 1, thickness: 1),
            textContainer("密码", 15, 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _passwordController,
                    autofocus: true,
                    obscureText: isHide,
                    maxLength: 16,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    //输入文本的样式
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: "",
                      hintText: '请输入密码',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: GlobalColors.textC1c1c1(),
                      ),
                    ),
                    keyboardType: TextInputType.number, //弹出数字键盘
                  ),
                ),
                new GestureDetector(
                  child: isHide
                      ? Image.asset("assets/images/close.png")
                      : Image.asset("assets/images/open.png"),
                  onTap: () {
                    setState(() {
                      isHide = !isHide;
                    });
                  },
                ),
              ],
            ),
            Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.only(top: 72),
              child: SizedBox(
                //子元素固定拉伸宽高
                width: double.infinity, //设置宽度最大
                height: 48,
                child: FlatButton(
                  splashColor: Colors.grey,
                  textColor: GlobalColors.whiteColor(),
                  color: GlobalColors.login849FDB(),
                  highlightColor: GlobalColors.login849FDB(),
                  child: Text("登录"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  onPressed: () {
                    if (Global.isMobileMatch(_mobileController.text)) {
                      NavigatorUtil.push(context, HomePage());
                    } else {
                      ToastView(
                        title: "请填写正确手机号",
                      ).showMessage();
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: new GestureDetector(
                    child: Text(
                      "手机号登录",
                      style: TextStyle(
                          fontSize: 16, color: GlobalColors.login849FDB()),
                    ),
                    onTap: () {
                      NavigatorUtil.push(context, LoginCodePage());
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    alignment: Alignment.centerRight, //文字靠右,
                    child: new GestureDetector(
                      child: Text(
                        "忘记密码",
                        style: TextStyle(
                            fontSize: 16, color: GlobalColors.login849FDB()),
                      ),
                      onTap: () {
                        ToastView(
                          title: "努力开发中......",
                        ).showMessage();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(children: <Widget>[
                Expanded(child: Divider(thickness: 1)), //thickness 分割线厚度
                Text(" 第三方登录 "),
                Expanded(child: Divider(thickness: 1)),
              ]),
            ),
            Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: Image.asset("assets/images/qq.png"),
              ),
              Expanded(
                flex: 1,
                child: Image.asset("assets/images/WeChat.png"),
              ),
              Expanded(
                flex: 1,
                child: Image.asset("assets/images/micro-blog.png"),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Container textContainer(String text, double marginTop, double textSize) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: Text(
        text,
        style: TextStyle(fontSize: textSize, color: GlobalColors.text888888()),
      ),
    );
  }
}
