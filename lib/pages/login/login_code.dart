import 'dart:async';
import 'dart:ui';
import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/network/ApiService.dart';
import 'package:editor_2020_9/pages/home/HomePage.dart';
import 'package:editor_2020_9/pages/login/model/login_info_model.dart';
import 'package:editor_2020_9/pages/login/model/user_info_model.dart';
import 'package:editor_2020_9/utils/data_name_unitls.dart';
import 'package:editor_2020_9/utils/navigator_util.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/public_tool.dart';
import 'package:editor_2020_9/utils/sp_util.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginCodePage extends StatefulWidget {
  @override
  _LoginCodePageState createState() => _LoginCodePageState();
}

class _LoginCodePageState extends State<LoginCodePage> {
  TextEditingController _mobileController =
      TextEditingController(text: SpUtil.getString(DataName.USERMOBILE));
  TextEditingController _codeController = TextEditingController();
  bool isClick = false; //是否可点击
  Timer _timer;
  bool isAgree = false; //是否同意协议
  int _seconds = 60;
  String _verifyText = "获取验证码";

  // 60秒计时器
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      isClick = false;
      _seconds--;
      _verifyText = " $_seconds" + "s后重发";
      setState(() {});
      if (_seconds == 0) {
        _cancelTimer();
        isClick = true;
        _verifyText = "获取验证码";
        setState(() {});
      }
    });
  }

  // 取消倒计时的计时器。
  void _cancelTimer() {
    _seconds = 60;
    _timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mobileController.addListener(() {
      if (Global.isMobileMatch(_mobileController.text)) {
        isClick = true;
      } else {
        isClick = false;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      //处理键盘上弹报错问题
      backgroundColor: GlobalColors.backColor(),
      body: SingleChildScrollView(
        //整体布局可滑动
        child: Padding(
          padding: const EdgeInsets.only(left: 22, right: 22, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //靠左
            children: <Widget>[
              GestureDetector(
                child: Row(
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
                onTap: () => NavigatorUtil.push(context, HomePage()),
              ),
              Container(
                margin: EdgeInsets.only(top: 28, bottom: 5),
                child: Text(
                  "欢迎来到平行人",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700), //字体加粗 fontWeight
                ),
              ),
              textContainer("Welcome to.ping xing ren", 0, 18),
              textContainer("手机号", 52, 16),
              _mobileWidget(),
              Divider(height: 1, thickness: 1),
              textContainer("验证码", 15, 16),
              _sendCodeWidget(),
              Divider(height: 1, thickness: 1),
              _userAgreementWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 15),
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
                      if (!isAgree) {
                        ToastView(
                          title: "请阅读并同意使用协议",
                        ).showMessage();
                        return;
                      }
                      if (Global.isMobileMatch(_mobileController.text)) {
                        _loginAction();
                      } else {
                        ToastView(
                          title: "请填写正确手机号",
                        ).showMessage();
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: Text(
                  "未注册的手机号登录成功后自动注册",
                  style:
                      TextStyle(fontSize: 16, color: GlobalColors.textB1b1b1()),
                ),
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
              ])
            ],
          ),
        ),
      ),
    );
  }

  ///用户协议
  Padding _userAgreementWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(top: 4, right: 5),
            alignment: Alignment.topCenter,
            child: new GestureDetector(
              child: isAgree
                  ? Image.asset("assets/images/bulue_group.png")
                  : Image.asset("assets/images/grey_group.png"),
              onTap: () {
                setState(() {
                  isAgree = !isAgree;
                });
              },
            ),
          ),
          Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: "我已阅读并同意",
                  style: TextStyle(color: GlobalColors.text717171())),
              TextSpan(
                text: "《使用协议》",
                style: TextStyle(color: GlobalColors.login849FDB()),
                // recognizer:
              ),
              TextSpan(
                  text: "和",
                  style: TextStyle(color: GlobalColors.text717171())),
              TextSpan(
                text: "《隐私协议》",
                style: TextStyle(color: GlobalColors.login849FDB()),
                // recognizer://点击事件
              ),
              TextSpan(
                  text: "并授权平行人获得本机号码",
                  style: TextStyle(color: GlobalColors.text717171())),
            ])),
          ),
        ],
      ),
    );
  }

  ///发送验证码
  Row _sendCodeWidget() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _codeController,
            // autofocus: true,
            maxLength: 4,
            style: TextStyle(
              fontSize: 18.0,
            ),
            //输入文本的样式
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              hintText: '请输入验证码',
              hintStyle: TextStyle(
                fontSize: 18,
                color: GlobalColors.textC1c1c1(),
              ),
            ),
            // keyboardType: TextInputType.number, //弹出数字键盘
          ),
        ),
        FlatButton(
          color: isClick
              ? GlobalColors.orangeFfba00()
              : GlobalColors.buttonF5f9fa(),
          textColor:
              isClick ? GlobalColors.whiteColor() : GlobalColors.textC3c3c3(),
          child: Text(_verifyText),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
          //圆角弧度
          onPressed: () {
            if (isClick) {
              _clickSendCode();
            }
          },
        ),
      ],
    );
  }

//发送验证码
  void _clickSendCode() {
    if (Global.isMobileMatch(_mobileController.text)) {
      ApiService.sendCodeRequest(_mobileController.text).then((value) {
        int code = value["resp_code"];
        if (code == 200) {
          if (isClick) {
            setState(() {
              _startTimer();
            });
            ToastView(
              title: "验证码已发送",
            ).showMessage();
          }
        } else if (code == 20004) {
          ToastView(
            title: "该手机号今日获取验证码次数已用完，请明日再试",
          ).showMessage();
        } else {
          String message = value["resp_msg"];
          ToastView(
            title: message,
          ).showMessage();
        }
      });
    } else {
      ToastView(title: "请填写正确手机号").showMessage();
    }
  }

  ///手机号输入框
  TextField _mobileWidget() {
    return TextField(
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
    );
  }

  void _loginAction() async {
    //token信息
    String mobile = _mobileController.text;
    LoginInfoModel infoModel = await ApiService.getloginRequest(
        _mobileController.text, _codeController.text);
    UserInfoModel data = await ApiService.getUserInfo(infoModel.accessToken);
    if (infoModel != null) {
      await PublicTool.savaUserInfo(
          infoModel: infoModel, mobile: mobile, data: data);
      Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => new HomePage()),
        (route) => route == null,
      );
      ToastView(
        title: "登录成功",
      ).showMessage();
    }
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
