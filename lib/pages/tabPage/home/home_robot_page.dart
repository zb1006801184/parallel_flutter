import 'package:editor_2020_9/model/converse_model.dart';
import 'package:editor_2020_9/model/robot_message_model.dart';
import 'package:editor_2020_9/network/ApiService.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/nav_bar_config.dart';
import 'package:editor_2020_9/utils/public_unitls.dart';
import 'package:editor_2020_9/widgets/pop_menu_widget.dart';
import 'package:editor_2020_9/widgets/speech_widget.dart';
import 'package:flutter/material.dart';

import '../../../widgets/CommonWidgets.dart';
import 'items/home_list_item.dart';
import 'items/bottom_input_bar.dart';

class HomeRobotPage extends StatefulWidget {
  Map arguments;
  HomeRobotPage({Key key, this.arguments}) : super(key: key);
  @override
  _HomeRobotPageState createState() => _HomeRobotPageState();
}

class _HomeRobotPageState extends State<HomeRobotPage>
    with WidgetsBindingObserver
    implements InputBarDelegate, ConverseIetmDelegate {
  //机器人信息
  RobotMessageModel _model;
  //对话数据源
  List<ConverseModel> _dataList = [];
  //会话唯一标识
  String _robotUUID = '';
  ScrollController _controller = ScrollController();
  //键盘是否打开
  bool isKeyboardActived = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    _request();
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isKeyboardActived) {
        //打开
        isKeyboardActived = true;
      } else {
        //关闭
        isKeyboardActived = false;
      }
      _jumToBottom();
    });
  }

  void _request() async {
    Future.wait([
      ApiService.getRobotMessageRequest(
          '${Global?.userInfoModel?.selectedRobotId ?? 28}'),
      ApiService.getRobotUUIDRequest(),
    ]).then((results) {
      _model = results[0];
      _robotUUID = results[1]['data'];
      _configData();
    }).catchError((e) {
      print(e);
    });
  }

  void _requestChat({String content}) async {
    var data = await ApiService.robotChatContentRequest({
      'uuid': _robotUUID,
      'robotId': Global.userInfoModel?.selectedRobotId ?? '28',
      'question': content,
      'uniqueId': _model.uniqueId
    });
    List<ConverseModel> result =
        await PublicUnitls.homeConverseModel(data, robotId: _model.id);
    _dataList.addAll(result);

    setState(() {});
    Future.delayed(Duration(milliseconds: 500), () {
      _jumToBottom();
    });
  }

  void _configData() {
    _dataList.add(ConverseModel(
        content: _model.welcomes ?? '您好！欢迎使用平行人！',
        from: 1,
        type: 0,
        userModel:
            UserModel(headImage: _model.headImgUrl, name: _model.robotName)));
    setState(() {});
  }

  //########################action############################
  void _backAction() {}
  //发送文本消息
  void _submmitClick(String value, {int type, int from, String content}) {
    _dataList.add(ConverseModel(
        content: content ?? value,
        from: from ?? 0,
        type: type ?? 0,
        userModel: UserModel(headImage: null, name: 'zzz')));
    _requestChat(content: value);
    setState(() {});
    _jumToBottom();
  }

  void _jumToBottom() {
    _controller.jumpTo(_controller?.position.maxScrollExtent);
  }

  void _updateModel(int index, ConverseModel model) {
    _dataList[index - 1] = model;
  }

  _speechClick() {
    SpeechWidget.showSpeechWidget(context, _speechCallBack);
  }

  _speechCallBack(String result, String filePath) {
    if (result?.length > 0) {
          _submmitClick(result, type: null, content: result);
    }
  }

  //菜单点击
  _popMenuCallBack(value){
    int index = int.parse(value);
    print(index);
  }

  //########################widgets############################
  Widget _listWidget() {
    return ListView.separated(
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return SizedBox(
            height: 0,
          );
        }
        if ((_dataList?.length ?? 0) + 1 == index) {
          return SizedBox(
            height: 0,
          );
        }

        return _itemWidget(_dataList[index - 1], index: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 25,
          width: 1,
        );
      },
      itemCount: (_dataList?.length ?? 0) + 2,
    );
  }

  Widget _itemWidget(ConverseModel model, {int index}) {
    MessageType type;
    if (model.type == 0) {
      //文本消息
      type = MessageType.TextType;
    } else if (model.type == 1) {
      //图片
      type = MessageType.ImageMessageType;
    } else if (model.type == 2) {
      //语音
      type = MessageType.VoiceMessageType;
    } else if (model.type == 3) {
      //视频
      type = MessageType.VoideMeesageType;
    } else if (model.type == 4) {
      //列表
      type = MessageType.BusinessListType;
    }
    return HomeListItem(
      userType: model.from == 0 ? UserType.MeType : UserType.OtherType,
      messageType: type,
      model: model,
      delegate: this,
      index: index,
    );
  }

  //输入框
  Widget _bottomWiget() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: BottomInputBar(
        delegate: this,
      ),
    );
  }

// 导航栏
  AppBar _appBar() {
    return NavBarConfig.configConverseAppBar(
        _model?.robotName ?? '机器人昵称', context,
        // leftWidget: [NavBarConfig.leftButton(backAction: _backAction)],
        rightWidget: NavBarConfig.rightButtons(
            rightAction1: () {
              Navigator.of(context).pushNamed('/ConverseVoicePage');
            },
            rightAction2: () {
              PopMenu.showPopMenu(context,callBack: _popMenuCallBack);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Color(0xFFF2F2F2),
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            child: _listWidget(),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )),
          _bottomWiget(),
        ],
      ),
    );
  }

  @override
  void submmitClick(String value) {
    _submmitClick(value);
  }

  void speechClick() {
    _speechClick();
  }

  void updateModel(int index, ConverseModel model) {
    _updateModel(index, model);
  }
}
