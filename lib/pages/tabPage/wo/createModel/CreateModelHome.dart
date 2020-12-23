import 'dart:async';

import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/network/ApiUrl.dart';
import 'package:editor_2020_9/utils/UI.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:editor_2020_9/network/ApiService.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';
import 'RobotModelEntity.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/ClassifyEntity.dart';

/// 机器人建模
class CreateModelHome extends StatefulWidget {
  CreateModelHome({
    Key key,
    this.parentRobot,
  }) : super(key: key);
  @required
  List<RobotModelEntity> parentRobot = List();

  @override
  State<StatefulWidget> createState() {
    return _CreateModelHomeState();
  }
}

class _CreateModelHomeState extends State<CreateModelHome> {
  List<RobotModelEntity> _robotModels = List();
  List<RobotModelEntity> _clickedTabsModels = List(); //用于存放点击过的机器人数据

  ScrollController _controller = ScrollController();
  bool displayAddDialog = false; //创建机器人对话框是否已显示
  String _newRobotIndustry;
  String _childrenRobotName; //当前子级robotName

  //七牛token
  String token = '';

  //###添加
  void _rquest() async {
    ApiService.getQiniuTokenRequest().then((value) {
      token = value;
    });
  }

  ///弹出创建机器人对话框
  Future<void> _displayCreateDialog() async {
    String _crearRobotHead = ''; //创建机器人选择头像
    String newRobotName = '';
    int i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              return SimpleDialog(
                backgroundColor: GlobalColors.backColor(),
                title: const Text(
                  '创建机器人',
                ),
                contentPadding: EdgeInsets.only(bottom: 0),
                titleTextStyle:
                    TextStyle(fontSize: 17, color: GlobalColors.text2f2f2f()),
                children: <Widget>[
                  SimpleDialogOption(
                      onPressed: () async {
                        EasyLoading.show();
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        final syStorage = new SyFlutterQiniuStorage();
                        String key =
                            DateTime.now().millisecondsSinceEpoch.toString() +
                                '.' +
                                image.path.split('.').last;
                        var result =
                            await syStorage.upload(image.path, token, key);
                        _crearRobotHead = ApiUrl.IMAGE_URL + key;
                        print("上传后的用户头像" + _crearRobotHead);
                        state(() {});
                        EasyLoading.dismiss();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '机器人头像',
                                style: TextStyle(
                                    color: GlobalColors.text000000(),
                                    fontSize: 18),
                              ),
                            ),
                            Container(
                              width: 38,
                              height: 38,
                              child: CircleAvatar(
                                // radius: 50,
                                backgroundImage: NetworkImage(_crearRobotHead
                                        .isEmpty
                                    ? "http://diting-parallel-man.pingxingren.com/sp_1605598000541.png"
                                    : _crearRobotHead),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SimpleDialogOption(
                      child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '*名称',
                              style: TextStyle(
                                  color: GlobalColors.text000000(),
                                  fontSize: 18),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(15),
                                  // 限制最多字符
                                  WhitelistingTextInputFormatter(
                                      RegExp("[a-zA-Z0-9\u4e00-\u9fa5]")),
                                  //白名单限制中文英文汉字
                                ],
                                // keyboardType: TextInputType.number,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                maxLengthEnforced: false,
                                onChanged: (text) => {newRobotName = text},
                                decoration: InputDecoration(
                                  hintText: '不超过15个字符',
                                  hintStyle: TextStyle(
                                      color: GlobalColors.textB1b1b1(),
                                      fontSize: 17),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  //获得焦点下划线设为蓝色
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 1,
                          color: GlobalColors.lineDBDBDB(),
                        )
                      ],
                    ),
                  )),
                  SimpleDialogOption(
                      onPressed: () {
                        //todo 打开选择行业页面
                        Navigator.of(context)
                            .pushNamed('/select_industry')
                            .then((job) {
                          _classifyEntity = job;
                          print("选择的行业:" + _classifyEntity.name);
                          _newRobotIndustry = _classifyEntity.name;
                          state(() {});
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 49,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Text(
                                      '*行业',
                                      style: TextStyle(
                                          color: GlobalColors.text000000(),
                                          fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _newRobotIndustry == null
                                          ? "选择行业"
                                          : _newRobotIndustry,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: GlobalColors.textB1b1b1(),
                                          fontSize: 17),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Image.asset(
                                        'assets/images/icon_small_right_arrow.png'),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: GlobalColors.lineDBDBDB(),
                            )
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: double.infinity,
                    height: 46,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: FlatButton(
                                color: Color(0xffebebeb),
                                highlightColor: Colors.black12,
                                colorBrightness: Brightness.dark,
                                splashColor: Color(0xffebebeb),
                                child: Text(
                                  '取消',
                                  style: TextStyle(
                                      color: GlobalColors.text989898(),
                                      fontSize: 18),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4.0))),
                                onPressed: () {
                                  _newRobotIndustry = "选择行业";
                                  state(() {});
                                  Navigator.pop(context, -1);
                                },
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: FlatButton(
                                color: Color(0xff849FDB),
                                highlightColor: Colors.blue[700],
                                colorBrightness: Brightness.dark,
                                splashColor: Color(0xff849FDB),
                                child: Text(
                                  '确定',
                                  style: TextStyle(
                                      color: GlobalColors.whiteColor(),
                                      fontSize: 18),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(4.0))),
                                onPressed: () {
                                  if (newRobotName.isEmpty) {
                                    ToastView(
                                      title: '请输入机器人名称',
                                    ).showMessage();
                                    return;
                                  }
                                  if (_newRobotIndustry.isEmpty ||
                                      _newRobotIndustry == '选择行业') {
                                    ToastView(
                                      title: '请选择机器人行业',
                                    ).showMessage();
                                    return;
                                  }
                                  Navigator.pop(context, 0);
                                  _requireCreateRobot(_crearRobotHead,
                                      newRobotName, _newRobotIndustry);
                                },
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  ClassifyEntity _classifyEntity;

  ///请求创建新的机器人
  void _requireCreateRobot(String avatar, String name, String industry) {
    /// todo 请求接口创建机器人
    var parentId = 0;
    var parentRobotLength = _clickedTabsModels.length;
    if (parentRobotLength > 0) {
      parentId = _clickedTabsModels[parentRobotLength - 1].id;
    }
    var params = {
      "applicationIndustry": _classifyEntity.id,
      "headImgUrl": avatar,
      "parentId": parentId,
      "robotName": name
    };
    ApiService.createRobot(params)
        .then((respCode) => {_createSuccess(respCode)});
    // RobotModelEntity newR = RobotModelEntity('机器人$name', industry,
    //     level: 1, nextLevel: true, robotAvatar: avatar);
    // _addModelTest(newR);
  }

  void _createSuccess(respCode) {
    if (respCode == 200) {
      ToastView(title: "创建成功").showMessage();
      var parentId = 0;
      var parentRobotLength = _clickedTabsModels.length;
      if (parentRobotLength > 0) {
        parentId = _clickedTabsModels[parentRobotLength - 1].id;
      }
      _getRobots(parentId);
    } else if (respCode == 10100) {
      ToastView(title: "该名字已被占用").showMessage();
    } else {
      ToastView(title: "创建失败").showMessage();
    }
  }

  void _addModelTest(RobotModelEntity newR) {
    if (newR == null) {
      return;
    }
    _robotModels.add(newR);
    _refreshView();
    UI.hideLoadingDialog(context);
  }

  ///进入下一级子机器人
  void _nextLevelRobot(RobotModelEntity robot) {
    List<RobotModelEntity> pr = List();
    for (var r in _clickedTabsModels) {
      pr.add(r);
    }
    pr.add(robot);
    _newRobotIndustry = robot.applicationIndustry;
    _childrenRobotName = robot.robotName;
    print("机器人建模下一级数据" + robot.robotName);
    setState(() {});
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => CreateModelHome(parentRobot: pr)))
        .then((index) => {
              if (index - 1 > 0) {Navigator.pop(context, index - 1)}
            });
    // setState(() {
    //   _clickedTabsModels.add(robot);
    // });
    // Timer(Duration(milliseconds: 100),
    //     () => _controller.jumpTo(_controller.position.maxScrollExtent));
    //todo 查询下一级的机器人数据，并装入_robotModels,更新ui
  }

  ///用户点击了tab按钮切换层级
  void _switchRobotLevel(int index) {
    print('tab点击-index:${index}');
    Navigator.pop(context, index + 1);
    // setState(() {
    //   _clickedTabsModels.removeRange(index + 1, _clickedTabsModels.length);
    // });
    // Timer(Duration(milliseconds: 100),
    //     () => _controller.jumpTo(_controller.position.maxScrollExtent));
    //todo 查询index级别的机器人，并更新
  }

  void _refreshView() {
    setState(() {});
  }

  static List<RobotModelEntity> toList(records) {
    List<RobotModelEntity> data = List();
    for (var record in records) {
      data.add(RobotModelEntity.fromMap(record));
    }
    return data;
  }

  void _refreshRobots(records) {
    List<RobotModelEntity> robotModels = toList(records);
    setState(() {
      _robotModels = robotModels;
    });
  }

  void _getRobots(parentId) {
    ApiService.getRobotList(parentId)
        .then((records) => {_refreshRobots(records)});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rquest();
    _clickedTabsModels = _getParentRobot();
    print("父级机器人：" + _clickedTabsModels.toString());
    var parentId = 0;
    var parentRobotLength = _clickedTabsModels.length;
    print('父级列表-parentRobotLength：${parentRobotLength}');
    if (parentRobotLength > 0) {
      Timer(Duration(milliseconds: 100),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));
      parentId = _clickedTabsModels[parentRobotLength - 1].id;
    }
    _getRobots(parentId);
  }

  List<RobotModelEntity> _getParentRobot() {
    return widget.parentRobot;
  }

  @override
  Widget build(BuildContext context) {
    ///返回显示机器人所在层级的view
    Widget _createLevelTabView(int index) {
      RobotModelEntity robot = _clickedTabsModels.elementAt(index);
      int count = _clickedTabsModels.length;
      if (index == 0 && count == 1) {
        //只有一个
        return Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              _switchRobotLevel(index);
            },
            child: Text(
              robot.robotName,
              style: TextStyle(color: GlobalColors.text3e3e3e(), fontSize: 17),
            ),
          ),
        );
      } else if (index == 0) {
        return Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: InkWell(
              onTap: () {
                _switchRobotLevel(index);
              },
              child: Text(
                robot.robotName,
                style: TextStyle(color: GlobalColors.grayColor(), fontSize: 17),
              )),
        );
      } else if (index + 1 == count) {
        //
        return Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: InkWell(
              onTap: () {
                _switchRobotLevel(index);
              },
              child: Text(
                '\t>\t' + robot.robotName,
                style:
                    TextStyle(color: GlobalColors.text3e3e3e(), fontSize: 17),
              )),
        );
      } else {
        return Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: InkWell(
              onTap: () {
                _switchRobotLevel(index);
              },
              child: Text(
                '\t>\t' + robot.robotName,
                style: TextStyle(color: GlobalColors.grayColor(), fontSize: 17),
              )),
        );
      }
    }

    ///点击了进入子级
    Widget _haveNextLevelRobot(RobotModelEntity robot) {
      return Container(
        margin: EdgeInsets.only(right: 15),
        child: InkWell(
          onTap: () {
            _nextLevelRobot(robot);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icon_robot_model.png'),
              Text(
                '进入子级',
                style: TextStyle(color: Color(0xffB2B2B2), fontSize: 14),
              )
            ],
          ),
        ),
      );
    }

    ///type:0为删除对话框  1为切换机器人
    _showAlertDialog(BuildContext context, int index, int type) {
      //设置按钮
      Widget cancelButton = FlatButton(
        child: Text(
          type == 0 ? "取消" : "否",
          style: TextStyle(fontSize: 16, color: GlobalColors.text989898()),
        ),
        onPressed: () {
          Navigator.of(context).pop("Cancel");
        },
      );
      Widget continueButton = FlatButton(
        child: Text(type == 0 ? "删除" : "是",
            style: TextStyle(
                fontSize: 16,
                color: type == 0 ? Colors.red : GlobalColors.login849FDB())),
        onPressed: () {
          Navigator.of(context).pop("Ok");
          if (type == 0) {
            ApiService.deleteRobotInfo(
                    _robotModels.elementAt(index).id.toString())
                .then((value) {
              if (value == 200) {
                _robotModels.removeAt(index);
                setState(() {});
              }
            });
          } else {
            //切换机器人
            ApiService.selectRobot(_robotModels.elementAt(index).id);
          }
        },
      );
      //设置对话框
      AlertDialog alert = AlertDialog(
        content: Text(type == 0 ? "删除该机器人时他下面的全部子机器人也被删除" : "用户身份是否切换到该机器人"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      //显示对话框
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Widget _updateRobotModelView(int index) {
      RobotModelEntity robot = _robotModels.elementAt(index);
      return Slidable(
        actionPane: SlidableDrawerActionPane(), //滑动风格
        secondaryActions: <Widget>[
          //右侧按钮列表
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            closeOnTap: false,
            onTap: () {
              _showAlertDialog(context, index, 0);
            },
          ),
        ],
        child: GestureDetector(
          child: Container(
            width: double.infinity,
            height: 61,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  margin: EdgeInsets.only(left: 15),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(robot.headImgUrl == null
                        ? "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2898349460,268201268&fm=26&gp=0.jpg"
                        : robot.headImgUrl),
                    backgroundColor: Color.fromARGB(0, 0, 0, 0),
                    radius: 100.0,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            robot.robotName == null ? "机器人名称" : robot.robotName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xff3E3E3E), fontSize: 17),
                          ),
                          Text(
                            robot.applicationIndustry == null
                                ? "其他行业"
                                : robot.applicationIndustry,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xffB2B2B2), fontSize: 16),
                          )
                        ],
                      ),
                    )),
                _haveNextLevelRobot(robot),
              ],
            ),
          ),
          onTap: () {
            _showAlertDialog(context, index, 1);
          },
        ),
      );
    }

    Widget _currentLevelTab() {
      return _clickedTabsModels.length > 0
          ? Container(
              color: GlobalColors.backColor(),
              height: 45,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              alignment: Alignment.center,
              width: double.infinity,
              child: ListView.builder(
                  controller: _controller,
                  itemCount: _clickedTabsModels.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return _createLevelTabView(index);
                  }),
            )
          : SizedBox();
    }

    ///创建机器人按钮
    Widget _createRobotButton() {
      return Container(
        width: double.infinity,
        height: 80,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: FlatButton.icon(
            color: Color(0xff849FDB),
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Color(0xff849FDB),
            icon: Icon(Icons.add_circle_outline),
            label: Text(
              '创建机器人',
              style: TextStyle(color: GlobalColors.whiteColor(), fontSize: 16),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            onPressed: () {
              _displayCreateDialog();
            },
          ),
        ),
      );
    }

    Widget _robotListView() {
      return Expanded(
        child: ListView.separated(
          itemCount: _robotModels.length,
          //列表项构造器
          itemBuilder: (BuildContext context, int index) {
            return _updateRobotModelView(index);
          },
          //分割器构造器
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Color(0xffEAEAEA),
              indent: 15,
              endIndent: 15,
            );
          },
        ),
      );
    }

    return Scaffold(
        backgroundColor: GlobalColors.backColor(),
        appBar: CommonWidgets.titleBar(
            context, _childrenRobotName == null ? '机器人建模' : _childrenRobotName,
            showIcon: true, moreAssets: 'assets/images/icon_search.png'),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              _currentLevelTab(),
              Divider(
                height: 1,
                color: GlobalColors.grayColor(),
              ),
              _createRobotButton(),
              _robotListView()
            ],
          ),
        ));
  }
}
