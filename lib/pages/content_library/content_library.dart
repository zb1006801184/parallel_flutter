import 'package:editor_2020_9/constants/GlobalColor.dart';
import 'package:editor_2020_9/network/ApiService.dart';
import 'package:editor_2020_9/pages/content_library/_photo_gallery_page.dart';
import 'package:editor_2020_9/pages/content_library/model/content_question_model.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/CreateModelHome.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/RobotModelEntity.dart';
import 'package:editor_2020_9/utils/date_unitls.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

import 'model/contenr_industry_model.dart';
import './vodie_page.dart';

///内容库
class ContentLibrary extends StatefulWidget {
  @override
  _ContentLibraryState createState() => _ContentLibraryState();
}

class _ContentLibraryState extends State<ContentLibrary>
    implements EnclosureState {
  TextEditingController _className = TextEditingController(); //弹框分类名称
  List<ContentIndustryModel> _industryModelList = [];
  List<ContentQuestionModel> _questionModelList = [];
  int currentindex = 0; //当前点击的行业index
  EasyRefreshController _controller;
  EasyRefreshController _controller2;
  int _industryPageNum;
  int _questionPageNum;
  bool _isNoInadvertently = false; //是否为展示无意图
  ContentQuestionModel questionModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    _controller2 = EasyRefreshController();
    _onIndustryRefresh();
  }

  ///行业分类刷新数据
  Future<void> _onIndustryRefresh() async {
    _industryPageNum = 1;
    await Future.delayed(Duration(seconds: 1)).then((e) {
      setState(() {
        ApiService.getContnetClassRequest(1, (e) {
          ToastView(title: "机器人不存在").showMessage();
        }).then((value) {
          _industryModelList.clear();
          _industryModelList = value;
          _questionOnRefresh();
          setState(() {});
        });
      });
    });
  }

  void _createModel(BuildContext context) {
    List<RobotModelEntity> robots = List();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateModelHome(
              parentRobot: robots,
            )));
  }

  ///行业分类加载新数据
  void _retrieveIndustryData() {
    //上拉加载新的数据
    Future.delayed(Duration(seconds: 1)).then((e) {
      ApiService.getContnetClassRequest(_industryPageNum, e).then((value) {
        _industryModelList.addAll(value);
        setState(() {});
      });
    });
  }

  ///问题列表分类加载新数据
  void _retrieveQuestionData() {
    //上拉加载新的数据
    Future.delayed(Duration(seconds: 1)).then((e) {
      ApiService.getContnetTemplateRequest(
              _questionPageNum, _industryModelList[currentindex].id)
          .then((value) {
        _questionModelList.addAll(value);
        setState(() {});
      });
    });
  }

  ///问题列表刷新数据
  Future<void> _questionOnRefresh() async {
    _questionPageNum = 1;
    await Future.delayed(Duration(seconds: 1)).then((e) {
      setState(() {
        ApiService.getContnetTemplateRequest(
                _questionPageNum, _industryModelList[currentindex].id)
            .then((value) {
          _questionModelList.clear();
          _questionModelList = value;
          if (_questionModelList.isEmpty) {
            _isNoInadvertently = true;
          } else {
            _isNoInadvertently = false;
          }
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _scaffoldWidget(context);
  }

  ///初始化
  Scaffold _scaffoldWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.buttonF7f7f7(),
      appBar: CommonWidgets.titleBar(context, '${Global.userInfoModel.robotName}的内容库',
          showIcon: true, moreAssets: 'assets/images/icon_search.png'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _addClassButton(),
              _addQaButton(),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                _industryList(),
                _isNoInadvertently
                    ? Column(
                        children: [
                          Container(
                            width: Global.ksWidth / 3 * 2,
                            child: Image.asset(
                                "assets/images/picture_no_content.png"),
                          ),
                          Text(
                            "内容空空的哦~快去添加一个吧",
                            style: TextStyle(
                                fontSize: 15, color: GlobalColors.textA8a8a8()),
                          )
                        ],
                      )
                    : _qaList()
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///无意图
  Row _noInadvertently() {
    return Row(
      children: [
        Container(
          color: GlobalColors.buttonF7f7f7(),
          width: Global.ksWidth / 3,
          height: Global.ksHeight,
          padding: EdgeInsets.only(top: 15, left: 28),
          child: Text(
            "无意图",
            style: TextStyle(fontSize: 16, color: GlobalColors.text848484()),
          ),
        ),
      ],
    );
  }

  ///问答列表
  Expanded _qaList() {
    return Expanded(
      flex: 2,
      child: Container(
        width: Global.ksWidth / 3 * 2,
        child: EasyRefresh(
          controller: _controller2,
          enableControlFinishRefresh: false,
          footer: MaterialFooter(
            overScroll: true,
            enableInfiniteLoad: false,
          ),
          onLoad: () async {
            _questionPageNum++;
            if (_questionPageNum <= Global.questionPage) {
              await _retrieveQuestionData();
              _controller2.resetLoadState();
            } else {
              _controller2.finishLoad(noMore: true);
              setState(() {});
              print("没有更多数据");
            }
          },
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: GlobalColors.whiteColor(),
                  padding:
                      EdgeInsets.only(left: 18, right: 18, bottom: 15, top: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: this._widgetList(index),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                    thickness: 1, color: GlobalColors.buttonF7f7f7());
              },
              itemCount: _questionModelList?.length ?? 0),
        ),
      ),
    );
  }

  ///分割线
  Padding _paddingDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Divider(thickness: 1, color: GlobalColors.lineEbebeb()),
    );
  }

  Offstage _paddingDividerOffStage(Answers answers) {
    return Offstage(
      offstage: answers.answer == null ? true : false,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Divider(thickness: 1, color: GlobalColors.lineEbebeb()),
      ),
    );
  }

  ///问题
  Text _problemWidget(int index) {
    ContentQuestionModel model = _questionModelList[index];
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: "问题：",
          style: TextStyle(
            fontSize: 16,
            color: GlobalColors.textA8a8a8(),
          ),
        ),
        TextSpan(
          text: model != null ? model.question : "",
          style: TextStyle(
            fontSize: 16,
            color: GlobalColors.text464646(),
          ),
        ),
      ]),
    );
  }

  @override
  void updateEnclosureState(bool isOffstage, int index) {
    // TODO: implement updateEnclosureState
    ContentQuestionModel model = _questionModelList[index];
    model.isOffstage = isOffstage;
    _questionModelList[index] = model;
  }

  List<Widget> _widgetList(int index) {
    List<Widget> list = new List();
    questionModel = _questionModelList[index];
    List<Answers> answers = questionModel.answers;
    list.add(_problemWidget(index));
    list.add(_paddingDivider());
    print("回答中所有数据杀杀杀是是是是咚咚咚：" + questionModel.toJson().toString());
    for (int i = 0; i < answers.length; i++) {
      list.add(_answerWidget(answers[i]));
      list.add(_paddingDividerOffStage(answers[i]));
    }
    list.add(_SeeEnclosureWidget(
      list: answers,
      state: this,
      offstage: questionModel.isOffstage,
      index: index,
    ));
    list.add(_paddingDivider());
    list.add(_bottomBarWidget(index, questionModel));

    return list;
  }

  ///答案
  Offstage _answerWidget(Answers answers) {
    return Offstage(
      offstage: answers.answer == null ? true : false,
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: "答案：",
            style: TextStyle(
              fontSize: 16,
              color: GlobalColors.textA8a8a8(),
            ),
          ),
          TextSpan(
            text: answers.answer,
            style: TextStyle(
              fontSize: 16,
              color: GlobalColors.text464646(),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///行业list列表
  Container _industryList() {
    return Container(
      width: Global.ksWidth / 3,
      color: GlobalColors.buttonF7f7f7(),
      child: EasyRefresh(
        controller: _controller,
        //禁止下拉刷新
        enableControlFinishRefresh: false,
        header: MaterialHeader(),
        footer: MaterialFooter(
          overScroll: true,
          enableInfiniteLoad: false,
        ),
        onLoad: () async {
          _industryPageNum++;
          if (_industryPageNum <= Global.industryPage) {
            await _retrieveIndustryData();
            _controller.resetLoadState();
          } else {
            _controller.finishLoad(noMore: true);
            setState(() {});
            print("没有更多数据");
          }
        },
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _industryModelList?.length ?? 0,
          //列表项构造器
          itemBuilder: (BuildContext context, int index) {
            ContentIndustryModel model = _industryModelList[index];
            return GestureDetector(
              child: Container(
                color: index == currentindex
                    ? GlobalColors.login849FDB()
                    : GlobalColors.buttonF7f7f7(),
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                child: Text(
                  model != null ? model.typeName : "",
                  style: TextStyle(
                    fontSize: 16,
                    color: index == currentindex
                        ? GlobalColors.whiteColor()
                        : GlobalColors.text848484(),
                  ),
                ),
              ),
              onTap: () {
                currentindex = index;
                _questionModelList.clear();
                _questionOnRefresh();
              },
              onLongPress: () {
                _className = new TextEditingController(text: model.typeName);
                _alertDialog("编辑分类", model.id);
              },
            );
          },
          //分割器构造器
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: GlobalColors.lineF0f0f0());
          },
        ),
      ),
    );
  }

  ///添加问答按钮
  Expanded _addQaButton() {
    return Expanded(
      flex: 1,
      child: Container(
        height: 42,
        margin: EdgeInsets.only(left: 10, top: 18, bottom: 20, right: 20),
        child: RaisedButton.icon(
          icon: Image.asset("assets/images/btn_addto.png"),
          label: Text(
            "添加问答",
            style: TextStyle(fontSize: 17),
          ),
          textColor: GlobalColors.whiteColor(),
          color: GlobalColors.login849FDB(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
          onPressed: () {
            Navigator.of(context).pushNamed('/AddContentPage', arguments: {
              'typeName': _industryModelList[currentindex].typeName,
              'parentId': _industryModelList[currentindex].id,
              'type': 0,
            });
            _onIndustryRefresh();
          },
        ),
      ),
    );
  }

  ///添加分类按钮
  Expanded _addClassButton() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 18, bottom: 15, right: 10),
        height: 42,
        child: RaisedButton.icon(
          icon: Image.asset("assets/images/btn_addto.png"),
          label: Text(
            "添加分类",
            style: TextStyle(fontSize: 17),
          ),
          textColor: GlobalColors.whiteColor(),
          color: GlobalColors.orangeFfba00(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
          onPressed: () {
            _className = new TextEditingController(text: "");
            _alertDialog("添加分类", 0);
          },
        ),
      ),
    );
  }

//Dialog弹框
  _alertDialog(String text, int id) {
    var result = showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0), //去除默认边距
            title: Center(
              child: Text(
                text,
                style:
                    TextStyle(color: GlobalColors.text2f2f2f(), fontSize: 17),
              ),
            ),
            children: [
              SimpleDialogOption(
                padding:
                    EdgeInsets.only(bottom: 30, left: 25, right: 25, top: 10),
                child: TextField(
                  maxLength: 6,
                  controller: _className,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  //输入文本的样式
                  decoration: InputDecoration(
                    // 未获得焦点下划线设为灰色
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: GlobalColors.lineDBDBDB()),
                    ),
                    //获得焦点下划线设为蓝色
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: GlobalColors.lineDBDBDB()),
                    ),
                    counterText: "",
                    //去除底部字数显示
                    hintText: '请输入6个字以内的分类名称',
                    hintStyle: TextStyle(
                      fontSize: 17,
                      color: GlobalColors.textC1c1c1(),
                    ),
                  ),
                  keyboardType: TextInputType.number, //弹出数字键盘
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 46,
                      color: GlobalColors.lineEbebeb(),
                      child: FlatButton(
                        child: Text(
                          "取消",
                          style: TextStyle(
                              fontSize: 18, color: GlobalColors.text989898()),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop("Cancel");
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 46,
                      color: GlobalColors.login849FDB(),
                      child: FlatButton(
                        child: Text(
                          "确定",
                          style: TextStyle(
                              fontSize: 18, color: GlobalColors.whiteColor()),
                        ),
                        onPressed: () {
                          if (_className.text.isEmpty) {
                            ToastView(
                              title: "分类名称不可为空",
                            ).showMessage();
                            return;
                          }
                          if (id == 0) {
                            //添加分类
                            var params = {
                              "parentId": id,
                              "robotId": Global.userInfoModel.selectedRobotId
                                  .toString(),
                              "typeName": _className.text,
                            };
                            ApiService.createContentType(params);
                            _onIndustryRefresh();
                          } else {
                            ApiService.editContentType(_className.text, id);
                            _industryModelList[currentindex].typeName =
                                _className.text;
                            setState(() {});
                          }
                          Navigator.of(context).pop("Ok");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
    print(result);
  }

  ///删除对话框
  _showAlertDialog(BuildContext context, int id, int index) {
    //设置按钮
    Widget cancelButton = FlatButton(
      child: Text(
        "取消",
        style: TextStyle(fontSize: 16, color: GlobalColors.text989898()),
      ),
      onPressed: () {
        Navigator.of(context).pop("Cancel");
      },
    );
    Widget continueButton = FlatButton(
      child: Text("确定",
          style: TextStyle(fontSize: 16, color: GlobalColors.login849FDB())),
      onPressed: () {
        Navigator.of(context).pop("Ok");
        ApiService.deleteQuestions(id);
        _questionModelList.removeAt(index);
        setState(() {});
      },
    );
    //设置对话框
    AlertDialog alert = AlertDialog(
      content: Text("是否确定删除该问答，删除后不能被找回"),
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

  ///底部发布栏
  Row _bottomBarWidget(int index, ContentQuestionModel model) {
    int _status = model.status;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Row(
            children: [
              _status == 0
                  ? Image.asset("assets/images/icon_release.png")
                  : Image.asset("assets/images/icon_withdraw.png"),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  _status == 0 ? "发布" : "撤销",
                  style: TextStyle(
                      color: _status == 0
                          ? GlobalColors.orangeFfba00()
                          : GlobalColors.text989898(),
                      fontSize: 18),
                ),
              ),
            ],
          ),
          onTap: () async {
            print("当前状态" + _status.toString());
            ApiService.updateContentState(model.id, _status == 0 ? 1 : 0);
            ContentQuestionModel info = _questionModelList[index];
            info.status = model.status == 1 ? 0 : 1;
            setState(() {});
          },
        ),

        ///编辑
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                child: Image.asset("assets/images/icon_edit.png"),
                onTap: () {
                  Navigator.of(context).pushNamed('/AddContentPage',
                      arguments: {
                        'type': 1,
                        'id': model.id,
                        "robotId": Global.userInfoModel.selectedRobotId
                      });
                },
              ),
            ),

            ///删除
            GestureDetector(
              child: Image.asset("assets/images/icon_delete.png"),
              onTap: () {
                _showAlertDialog(context, model.id, index);
              },
            ),
          ],
        ),
      ],
    );
  }
}

///查看附件Widget
class _SeeEnclosureWidget extends StatefulWidget {
  List<Answers> list;
  EnclosureState state;
  bool offstage;
  int index;

  _SeeEnclosureWidget(
      {Key key, this.list, this.state, this.offstage, this.index})
      : super(key: key);

  @override
  _SeeEnclosureWidgetState createState() => _SeeEnclosureWidgetState();
}

class _SeeEnclosureWidgetState extends State<_SeeEnclosureWidget> {
  List<Answers> _answers;
  EnclosureState _state;
  bool _offstage;
  bool isData = false; //附件中是否有数据
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();
  var duration;

  _load(String audioUrl, String videoUrl) async {
    print("当前库以及" + audioUrl);
    print("当前库以及fff" + videoUrl);
    if (!audioUrl.isEmpty) {
      final player = AudioPlayer();
      duration = await player.setUrl(audioUrl);
    }
    // if (!videoUrl.isEmpty) {
    //   _controller =await VideoPlayerController.network(videoUrl);
    //   _controller.setLooping(true);
    //   _initializeVideoPlayerFuture = _controller.initialize();
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recordPlugin.init();
    _answers = widget.list;
    _state = widget.state;
    _offstage = widget.offstage;

    for (int i = 0; i < _answers.length; i++) {
      Answers answers = _answers[i];
      print("回答中所有数据：" + answers.toJson().toString());
      if (!answers.imgUrl.isEmpty ||
          !answers.videoUrl.isEmpty ||
          !answers.audioUrl.isEmpty ||
          !answers.hyperlinkUrl.isEmpty ||
          answers.applicationVo != null) {
        isData = true;
        if (!answers.audioUrl.isEmpty) {
          Future.delayed(
              Duration.zero,
              () => setState(() {
                    _load(answers.audioUrl, answers.videoUrl);
                  }));
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Row(
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "附件：",
                    style: TextStyle(
                      fontSize: 16,
                      color: GlobalColors.textA8a8a8(),
                    ),
                  ),
                  TextSpan(
                    text: !isData ? "暂无附件，请添加" : "查看附件 ",
                    style: TextStyle(
                      fontSize: 16,
                      color: GlobalColors.text464646(),
                    ),
                  ),
                ]),
              ),
              Offstage(
                offstage: !isData ? true : false,
                child: Container(
                  child: !_offstage
                      ? Image.asset("assets/images/btn_takeback.png")
                      : Image.asset("assets/images/btn_open.png"),
                ),
              ),
            ],
          ),
          onTap: () {
            if (!isData) {
            } else {
              //点击
              _offstage = !_offstage;
              _state.updateEnclosureState(_offstage, widget.index);
              setState(() {});
            }
          },
        ),
        Offstage(
          offstage: !_offstage,
          child: Container(
            margin: EdgeInsets.only(top: 15, bottom: 10),
            child: Column(
              children: _EnclosurewidgetList(_answers),
            ),
          ),
        ),
      ],
    );
  }

  ///附件中list
  List<Widget> _EnclosurewidgetList(List<Answers> answers) {
    List<Widget> list = new List();
    for (int i = 0; i < answers.length; i++) {
      Answers answer = answers[i];
      print("附件中的所有数据" + answer.toJson().toString());
      list.add(_voiceWidget(answer));
      list.add(_videoWidget(answer));
      list.add(_picturesWidget(answer));
      list.add(_phoneWidget(answer));
      list.add(_linkWidget(answer));
    }
    return list;
  }

  ///附件图片
  Offstage _picturesWidget(Answers answers) {
    return Offstage(
      offstage: answers.imgUrl.isEmpty ? true : false,
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          height: 100,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(answers.imgUrl, fit: BoxFit.fill), //图片充满父容器
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SeePhotoPage(
                    imageUrl: answers.imgUrl,
                  )));
        },
      ),
    );
  }

  ///附件视频
  Offstage _videoWidget(Answers answers) {
    String time = "";
    if (!answers.videoUrl.isEmpty) {
      ApiService.getQN(answers.videoUrl + "?avinfo").then((value) {
        time = DateUnitls.secondChangeDate(double.parse(value));
      });
    }
    print('当前视频in' + answers.videoUrl.toString());
    return Offstage(
      offstage: answers.videoUrl.isEmpty ? true : false,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 15),
            height: 100,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                  answers.videoUrl + "?vframe/jpg/offset/0", //视频第一帧
                  fit: BoxFit.fill), //图片充满父容器
            ),
          ),
          //开始播放按钮
          GestureDetector(
            child: Image.asset(
              "assets/images/btn_play.png",
            ),
            onTap: () {
              if (!answers.videoUrl.isEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoPage(
                          videoUrl: answers.videoUrl,
                        )));
              }
            },
          ),
          Positioned(
            right: 12,
            bottom: 20,
            child: Text(
              time,
              style: TextStyle(fontSize: 16, color: GlobalColors.whiteColor()),
            ),
          ),
        ],
      ),
    );
  }

  ///附件语音
  Offstage _voiceWidget(Answers answers) {
    return Offstage(
      offstage: answers.audioUrl.isEmpty ? true : false,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            GestureDetector(
              child: Image.asset(
                "assets/images/content_libray_voice.png",
              ),
              onTap: () {
                _palyVoiceUrl(answers.audioUrl);
              },
            ),
            // Text(time),
          ],
        ),
      ),
    );
  }

  void _palyVoiceUrl(String url) {
    recordPlugin.playByPath(url, 'url');
  }

  ///手机号
  Offstage _phoneWidget(Answers answers) {
    return Offstage(
      offstage: answers.applicationVo == null ? true : false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.all(15),
          color: GlobalColors.textF8f8f8(),
          height: 52,
          child: Row(
            children: [
              Image.asset(
                "assets/images/icon_telep_hone.png",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  answers == null
                      ? ""
                      : answers.applicationVo == null
                          ? ""
                          : answers.applicationVo.mobile == null
                              ? ""
                              : answers.applicationVo.mobile,
                  style: TextStyle(
                      fontSize: 18, color: GlobalColors.login849FDB()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///超链接
  Offstage _linkWidget(Answers answers) {
    return Offstage(
      offstage: answers.hyperlinkUrl.isEmpty ? true : false,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        color: GlobalColors.textF8f8f8(),
        height: 52,
        child: Row(
          children: [
            Image.asset(
              "assets/images/icon_llnk.png",
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                answers.hyperlinkUrl,
                style:
                    TextStyle(fontSize: 18, color: GlobalColors.login849FDB()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class EnclosureState {
  void updateEnclosureState(bool isOffstage, int index);
}
