import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:editor_2020_9/model/content_model.dart';
import 'package:editor_2020_9/pages/content_library/model/contenr_industry_model.dart';
import 'package:editor_2020_9/pages/tabPage/add/service/event_bus.dart';
import 'package:editor_2020_9/utils/date_unitls.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/public_tool.dart';
import 'package:editor_2020_9/utils/public_unitls.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record/index.dart';
import 'package:video_player/video_player.dart';

enum ContentType {
  ClassifyType, //问题分类
  QuestionType, //问题
  AnswerType, //回答
  AddAnswerType, //添加回答
  AttachmentType, //附件
  NoticeType, //提示
  SubmmitType, //提交
  AttachmentTitleType, //附件标题
  VoiceType, //一段录音
  ImageType, //图片
  VideoType, //视频
  LinkeType, //超链接
  PhoneApplyType, //电话应用
}

class AddContentItem extends StatefulWidget {
  ContentModel model;
  AddContentItemDelegate delegate;
  int index;
  AddContentItem(this.delegate, {Key key, this.model, this.index})
      : super(key: key);
  @override
  _AddContentItemState createState() => _AddContentItemState();
}

class _AddContentItemState extends State<AddContentItem> {
  ContentType _contentType;
  ContentModel _model;
  AddContentItemDelegate delegate;
  TextEditingController _controller = TextEditingController();
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();
  VideoPlayerController _videoController;
  Future _initializeVideoPlayerFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recordPlugin.init();
  }

//################actions################
  //点击问题分类
  void _addClassifyClick() async {
    if (_model.typeList.length >= 9) {
      ToastView(
        title: '分类不能超过九条',
      ).showMessage();
      return;
    }
    Navigator.of(context)
        .pushNamed('/ClassifyPage', arguments: {'robotId': _model.robotId})
          ..then((value) async {
            bool isAddClass =
                await PublicUnitls.duplicateClass(_model.typeList, value);
            if (value != null && isAddClass == false) {
              setState(() {
                _model.typeList.add(value);
              });
              if (delegate != null) {
                delegate.classifyClick(_model);
              }
            }
          });
  }

  //删除分类
  void _deleteClassiftClick({int index}) {
    // if (_model.typeList.length <= 1) {
    //   ToastView(
    //     title: '分类最少一条',
    //   ).showMessage();
    //   return;
    // }
    setState(() {
      _model.typeList.removeAt(index);
    });
    if (delegate != null) {
      delegate.classifyClick(_model);
    }
  }

  void _addMoreAnswer() {
    if (delegate != null) {
      delegate.didTapAddMoreAnswerItem();
    }
  }

  void _submmitClick({String title}) {
    if (delegate != null) {
      delegate.submmitClick(title);
    }
  }

  void _addAttachmentClick(title) {
    if (delegate != null) {
      delegate.attachmentClick(title);
    }
  }

  void _palyVoiceUrl() {
    if (_model.content.length > 0 && !_model.content.contains('http')) {
      recordPlugin.playByPath(_model.content, 'file');
    } else {
      recordPlugin.playByPath(_model.content, 'url');
    }
  }

  void _playVideo() {
    var bus = new EventBus();
    bus.emit('stop', _model);
    _videoController.value.isPlaying
        ? _videoController.pause()
        : _videoController.play();
  }

  void _onTextFieldChange(String value) {
    setState(() {});
    if (delegate != null) {
      delegate.textFieldChange(_model, widget.index, _controller);
    }
  }

//################widgets################
  Widget _mainWiget() {
    switch (_contentType) {
      case ContentType.ClassifyType:
        //问题分类
        return _classifyWiget();
        break;
      case ContentType.QuestionType:
        //输入问题
        return _questionWidget(title: '请输入问题');
        break;
      case ContentType.AnswerType:
        //输入答案
        return _questionWidget(title: '请输入回答', maxLeng: 450);
        break;
      case ContentType.AddAnswerType:
        //添加答案
        return _addAnswerWidget();
        break;
      case ContentType.AttachmentType:
        //添加附件
        return _addAttachmentWidget();
        break;
      case ContentType.NoticeType:
        //底部提示
        return _noticeWidget();
        break;
      case ContentType.SubmmitType:
        //底部按钮
        return _submmitWidget();
      case ContentType.AttachmentTitleType:
        //附件标题
        return _attachMentWidget();
        break;
      case ContentType.VoiceType:
        //一段录音
        return _voiceWidget();
        break;
      case ContentType.ImageType:
        //图片
        return _imageWidget();
        break;
      case ContentType.VideoType:
        //视频
        return _videoWidget();
        break;
      case ContentType.PhoneApplyType:
        //手机应用
        return _phoneApplyWidget();
        break;
      case ContentType.LinkeType:
        //超链接
        return _linkWidget();
        break;
      default:
    }
  }

  ContentType _type(String title) {
    if (title == '问题分类：') {
      return ContentType.ClassifyType;
    } else if (title == '问题：') {
      return ContentType.QuestionType;
    } else if (title == '答案：') {
      return ContentType.AnswerType;
    } else if (title == '添加答案') {
      return ContentType.AddAnswerType;
    } else if (title == '附件') {
      return ContentType.AttachmentType;
    } else if (title == '提示') {
      return ContentType.NoticeType;
    } else if (title == '提交') {
      return ContentType.SubmmitType;
    } else if (title == '附件标题') {
      return ContentType.AttachmentTitleType;
    } else if (title == '一段录音') {
      return ContentType.VoiceType;
    } else if (title == '图片') {
      return ContentType.ImageType;
    } else if (title == '视频') {
      return ContentType.VideoType;
    } else if (title == '电话应用') {
      return ContentType.PhoneApplyType;
    } else if (title == '超链接') {
      return ContentType.LinkeType;
    }
    return null;
  }

  //问题分类
  Widget _classifyWiget() {
    return Container(
        constraints: BoxConstraints(minHeight: 67),
        padding: EdgeInsets.only(left: 15, top: 10),
        color: Colors.white,
        child: Wrap(
          children: _tagListWidget(),
        ));
  }

  List<Widget> _tagListWidget() {
    List<Widget> result = [];
    result.add(Container(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        _model.title,
        style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
      ),
    ));
    if (_model.typeList != null) {
      for (var i = 0; i < _model.typeList?.length ?? 0; i++) {
        ContentIndustryModel typeModel = _model.typeList[i];
        result.add(_tagWidget(index: i, title: typeModel.typeName));
      }
    }
    if (_model.typeList?.length < 9) {
      result.add(_addButtonWidget());
    }
    return result;
  }

  Widget _tagWidget({int index, String title}) {
    return Container(
      child: Stack(
        children: [
          Positioned(
              child: Container(
            padding: EdgeInsets.only(top: 3, bottom: 3, left: 14, right: 14),
            margin: EdgeInsets.only(right: 9, top: 9, bottom: 9),
            height: 27,
            decoration: BoxDecoration(
                color: Color(0xFF849FDB),
                borderRadius: BorderRadius.circular(27 / 2)),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          )),
          Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                child: Container(
                  width: 18,
                  height: 18,
                  child: Image.asset('assets/images/icon_content_delete.png'),
                ),
                onTap: () {
                  _deleteClassiftClick(index: index);
                },
              ))
        ],
      ),
    );
  }

  Widget _addButtonWidget() {
    return InkWell(
      child: Container(
        height: 46,
        width: 46,
        child: Center(
          child: Image.asset(
            'assets/images/icon_add_to.png',
            width: 28,
            height: 28,
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: _addClassifyClick,
    );
  }

  //问题、答案
  Widget _questionWidget({
    String title,
    int maxLeng = 60,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [_titleText(_model.title)],
          ),
          _questionInputWidget(title: title, maxLeng: maxLeng),
        ],
      ),
    );
  }

  Widget _questionInputWidget({
    String title,
    int maxLeng,
  }) {
    _controller.text = _model.content ?? '';
    if ((_model?.content?.length ?? 0) > maxLeng) {
      _controller.text = _model.content.substring(0, maxLeng);
    }
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 42),
            child: TextField(
              maxLines: null,
              maxLength: maxLeng,
              // controller: _controller,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.all(11),
                hintText: title ?? '',
                hintStyle: TextStyle(fontSize: 16, color: Color(0xFFB4B4B4)),
                labelStyle: TextStyle(fontSize: 16),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _controller.text = value;
                _onTextFieldChange(value);
              },
              textInputAction: TextInputAction.done,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: '${_controller.text == null ? "" : _controller.text}',
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: '${_controller.text}'.length)))),
            ),
          ),
          _inputBottomToolWidget(maxLeng: maxLeng),
        ],
      ),
    );
  }

  Widget _inputBottomToolWidget({
    int maxLeng,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 13),
      height: 42,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${_controller.text.length ?? 0}/${maxLeng}',
            style: TextStyle(fontSize: 14, color: Color(0xffB4B4B4)),
          ),
          GestureDetector(
            child: Container(
              width: 29,
              height: 29,
              margin: EdgeInsets.only(left: 9, right: 8),
              child: Image.asset('assets/images/icon_voice_input.png'),
            ),
            onTap: () {
              if (widget.delegate != null) {
                widget.delegate.speechToText(_model, widget.index);
              }
            },
          )
        ],
      ),
    );
  }

  //添加答案按钮

  Widget _addAnswerWidget() {
    if (_model.isShowAddAnswer == false) {
      return Container();
    }
    return GestureDetector(
      child: Container(
        height: 82,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 46,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/icon_frame.png'))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icon_addto.png'),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '添加答案',
                    style: TextStyle(color: Color(0xFF9D9D9D), fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                '*可以添加多个答案',
                style: TextStyle(
                    color: Color(
                      0xFFD80000,
                    ),
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      onTap: _addMoreAnswer,
    );
  }

  Widget _attachMentWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, top: 12, bottom: 16),
      child: Text(
        '附件',
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF000000),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //添加附件

  Widget _addAttachmentWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            width: Global.ksHeight,
            child: Row(
              children: [
                Expanded(
                    child: _attachmentTitleIconWidget(
                        title: '一段录音',
                        iconString: (_model.voiceNum ?? 0) < 9
                            ? 'assets/images/icon_addre_cording.png'
                            : 'assets/images/icon_addrecording_n.png')),
                Expanded(
                    child: _attachmentTitleIconWidget(
                        title: '图片视频',
                        iconString: (_model.videoNum ?? 0) < 9
                            ? 'assets/images/icon_picture_video.png'
                            : 'assets/images/icon_videopictures_n.png')),
                Expanded(
                    child: _attachmentTitleIconWidget(
                        title: '万能应用',
                        iconString: (_model.applyNum ?? 0) < 9
                            ? 'assets/images/icon_universal.png'
                            : 'assets/images/icon_universal_n.png')),
                Expanded(
                    child: _attachmentTitleIconWidget(
                        title: '超链接',
                        iconString: (_model.linkNum ?? 0) < 9
                            ? 'assets/images/icon_hyper_links.png'
                            : 'assets/images/icon_hyperlinks_n.png')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentTitleIconWidget({String title, String iconString}) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Container(
              width: 45,
              height: 45,
              child: Image.asset(
                iconString,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Color(0xFF6C6C6C)),
            )
          ],
        ),
      ),
      onTap: () {
        _addAttachmentClick(title);
      },
    );
  }

  //提示

  Widget _noticeWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 16, left: 15, right: 15, bottom: 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '提示：',
            style: TextStyle(fontSize: 15, color: Color(0xFF5F5F5F)),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '对于一个问题的多种不同表达，无需重复添加。例如“你们公司在哪里”和“你们在什么地方”',
            style: TextStyle(fontSize: 14, color: Color(0xFFB2B2B2)),
          ),
        ],
      ),
    );
  }

  Widget _submmitWidget() {
    return Container(
      color: Colors.white,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: _buttonWidget(
                  title: '保存草稿',
                  color: Color(0xFFF5F5F5),
                  titleColor: Color(0xFFA0A0A0))),
          Expanded(
              child: _buttonWidget(
                  title: '立即发布',
                  color: Color(0xFF849FDB),
                  titleColor: Colors.white))
        ],
      ),
    );
  }

  Widget _buttonWidget({String title, Color color, Color titleColor}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        height: 42,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: titleColor),
          ),
        ),
      ),
      onTap: () {
        _submmitClick(title: title);
      },
    );
  }

  Widget _voiceWidget() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 20, bottom: 20),
        color: Colors.white,
        child: Row(
          children: [
            Image.asset(
              'assets/images/add/btn_voice.png',
              height: 45,
              width: 201,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              DateUnitls.secondChangeDate(_model.voiceTime),
              style: TextStyle(fontSize: 16, color: Color(0xFF1F1F1F)),
            ),
          ],
        ),
      ),
      onTap: _palyVoiceUrl,
    );
  }

  Widget _imageWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            width: 102,
            height: 100,
            imageUrl: _model.content,
            fit: BoxFit.fill,
          ),
        ),
        onTap: () {
          PublicTool.imageBrowser(_model.content, context);
        },
      ),
    );
  }

  Widget _videoWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      color: Colors.white,
      child: Container(
        height: 102,
        child: Stack(
          children: [
            _videoPlay(),
            Center(
              child: GestureDetector(
                child: Image.asset(
                  'assets/images/btn_play.png',
                  width: 48,
                  height: 48,
                ),
                onTap: _playVideo,
              ),
            ),
            Positioned(
                right: 11,
                bottom: 8,
                child: Text(
                    DateUnitls.secondChangeDate(_model
                        .videoController.value.duration?.inSeconds
                        ?.toDouble()),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )))
          ],
        ),
      ),
    );
  }

  Widget _videoPlay() {
    _videoController = _model.videoController;
    _initializeVideoPlayerFuture = _model.initializeVideoPlayerFuture;
    var bus = new EventBus();
    bus.on('stop', (arg) {
      ContentModel model = arg;

      if (model.content != _model.content) {
        _videoController.value.isPlaying ? _videoController.pause() : null;
      }
    });

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: (Global.ksWidth - 40) / 102,
                      child: VideoPlayer(_videoController),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _phoneApplyWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
            color: Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Image.asset(
              'assets/images/btn_telep_hone.png',
              width: 16.8,
              height: 16.8,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              '电话应用',
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF535353),
                  fontWeight: FontWeight.w500),
            ),
            Container(
              height: 15,
              width: 1,
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Color(0xFFAFAFAF),
            ),
            Text(
              '${_model?.content}',
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF849FDB),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Image.asset(
              'assets/images/btn_link.png',
              width: 16.8,
              height: 16.8,
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              child: Text(
                _model.content ?? '',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF535353),
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {
                if (widget.delegate != null) {
                  widget.delegate.linkClick(_model);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleText(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, color: Color(0xFF1F1F1F)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _model = widget.model;
    delegate = widget.delegate;
    _contentType = _type(_model.title);
    return _mainWiget();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (mounted) {
      _videoController?.pause();
    }
  }
}

abstract class AddContentItemDelegate {
  void didTapAddMoreAnswerItem(); //添加更多答案
  void submmitClick(String title); //保存  立即发布点击
  void attachmentClick(String title); //添加附件
  void textFieldChange(
      ContentModel model, int index, TextEditingController controller); //输入框更变
  void classifyClick(ContentModel model); //添加、删除分类的回调
  void speechToText(ContentModel model, int index); //语音转文字回调
  void linkClick(
    ContentModel model,
  ); //点击超链接
}
