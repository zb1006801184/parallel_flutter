import 'package:cached_network_image/cached_network_image.dart';
import 'package:editor_2020_9/model/converse_model.dart';
import 'package:editor_2020_9/pages/content_library/_photo_gallery_page.dart';
import 'package:editor_2020_9/utils/public_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';
import 'package:video_player/video_player.dart';
import '../../../../utils/global.dart';

enum UserType {
  MeType, //我自己的消息
  OtherType, //别人的消息
}
enum MessageType {
  TextType, //文本消息
  BusinessListType, //企业列表类型
  ImageMessageType, //图片消息
  VoideMeesageType, //视频消息
  VoiceMessageType, //声音消息
}

class HomeListItem extends StatefulWidget {
  UserType userType;
  MessageType messageType;
  ConverseModel model;
  ConverseIetmDelegate delegate;
  int index;
  HomeListItem({
    Key key,
    this.userType, //用户类型
    this.messageType, //消息类型
    this.model, //机器人信息
    this.index,
    this.delegate,
  }) : super(key: key);
  static const String Error_Image_URL =
      'http://diting-parallel-man.pingxingren.com/sp_1605598000541.png';

  @override
  _HomeListItemState createState() => _HomeListItemState();
}

class _HomeListItemState extends State<HomeListItem> {
  UserType _userType;
  MessageType _messageType;
  ConverseModel _model;
  VideoPlayerController _videoController;
  Future _initializeVideoPlayerFuture;
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();
  @override
  void initState() {
    super.initState();
    _userType = widget.userType;
    _messageType = widget.messageType;
    _model = widget.model;
  }

  void configData() {
    //初始化语音插件
    recordPlugin.init();
  }

  void _palyVoiceUrl() {
    if (_model?.isReadVoice != true && widget.delegate != null) {
      _model.isReadVoice = true;
      widget.delegate.updateModel(widget.index, _model);
      setState(() {});
    }
    if (_model.content.length > 0 && !_model.content.contains('http')) {
      recordPlugin.playByPath(_model.content, 'file');
    } else {
      recordPlugin.playByPath(_model.content, 'url');
    }
  }

//########################actions########################
  _videoPlayClick() {
    _videoController?.value?.isPlaying
        ? _videoController?.pause()
        : _videoController?.play();
  }

  _editClick() {
    Navigator.of(context).pushNamed('/AddContentPage',
        arguments: {'type': 1, 'id': _model.id, 'robotId': _model.robotId});
  }

//########################widgets########################
  Widget _mainWidget() {
    switch (_messageType) {
      //文本消息
      case MessageType.TextType:
        return _textWidget();
        break;
      //企业列表消息
      case MessageType.BusinessListType:
        return _businessListWidget();
        break;
      //图片消息
      case MessageType.ImageMessageType:
        return _imageMessageWidget();
        break;
      //视频消息
      case MessageType.VoideMeesageType:
        return _voideMessageWidget();
        break;
      //语音消息
      case MessageType.VoiceMessageType:
        return _voiceMessageWidget();
        break;
      default:
        return Container();
    }
  }

//文本消息
  Widget _textWidget() {
    List<Widget> result = [];

    if (_userType == UserType.MeType) {
      result.add(_textContainer());
      result.add(_headImageWidget());
    } else {
      result.add(_headImageWidget());
      result.add(_textContainer());
    }

    return Container(
      padding: _userType == UserType.MeType
          ? EdgeInsets.only(
              left: 69,
              right: 20,
            )
          : EdgeInsets.only(
              left: 20,
              right: 69,
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: result,
      ),
    );
  }

  Widget _textContainer() {
    return Expanded(
        child: Container(
      padding: _userType == UserType.OtherType
          ? EdgeInsets.only(left: 10)
          : EdgeInsets.only(right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: _userType == UserType.OtherType
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (_userType == UserType.OtherType)
            Container(
              width: 11,
              height: 8,
              child: _angleWidget(),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: Global.ksWidth - 47 - 30 - 69 - 9 - 29),
            padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: _textContentColor(),
                borderRadius: _contextBorderRadius()),
            child: Text(
              _model?.content ?? '未知消息',
              maxLines: 9999,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, color: _textColor()),
            ),
          ),
          if (_userType == UserType.MeType)
            Container(
              width: 11,
              height: 8,
              child: _angleWidget(),
            ),
          if (_model.isCanEdit == true) _editButtonWidget(),
        ],
      ),
    ));
  }

  Widget _angleWidget() {
    if (_userType == UserType.MeType) {
      return Image.asset(
        'assets/images/picture_chat_user.png',
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/picture_chat_robot.png',
        fit: BoxFit.cover,
      );
    }
  }

//企业列表消息
  Widget _businessListWidget() {
    return Container(
      margin: EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(6)),
      child: Column(
        children: _businesslistItemWidget(),
      ),
    );
  }

  List<Widget> _businesslistItemWidget() {
    List<Widget> result = [];
    List dataList = ['法务机器人', '智能人事机器人', '考勤机器人', '财务机器人'];
    dataList.forEach((element) {
      result.add(_listItemWidget(title: element));
    });
    return result;
  }

  Widget _listItemWidget({String title}) {
    return Container(
      height: 74,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: _headImageWidget(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Color(0xFF3E3E3E), fontSize: 17),
                    ),
                    Text(
                      '公司法律业务',
                      style: TextStyle(color: Color(0xFFB2B2B2), fontSize: 17),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            color: Color(0xFFEFEFEF),
          )
        ],
      ),
    );
  }

  //图片消息
  Widget _imageMessageWidget() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: _headImageWidget(),
          ),
          _imageContentWidget(),
          if (_model.isCanEdit == true)
            Container(
              height: 164,
              child: Center(
                child: _editButtonWidget(),
              ),
            ),
        ],
      ),
    );
  }


  Widget _imageContentWidget() {
    return GestureDetector(
      child: Container(
          width: 127,
          height: 164,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: _model.content,
              fit: BoxFit.cover,
            ),
          )),
      onTap: () {
        
        PublicTool.imageBrowser(_model.content, context);
      },
    );
  }

  //视频消息
  Widget _voideMessageWidget() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: _headImageWidget(),
          ),
          _videoContentWidget(),
          if (_model.isCanEdit == true)
            Container(
              height: 112,
              child: Center(
                child: _editButtonWidget(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _videoContentWidget() {
    _videoController = _model.videoController;
    _initializeVideoPlayerFuture = _model.initializeVideoPlayerFuture;
    return GestureDetector(
      child: Container(
        width: 197,
        height: 112,
        child: Stack(
          children: [
            _videoPlay(),
            Center(
              child: Image.asset(
                'assets/images/btn_play.png',
                width: 45,
                height: 45,
              ),
            )
          ],
        ),
      ),
      onTap: _videoPlayClick,
    );
  }

  Widget _videoPlay() {
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
                      aspectRatio: 197 / 112,
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

  //语音消息
  Widget _voiceMessageWidget() {
    return Container(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: _headImageWidget(),
        ),
        GestureDetector(
          child: _voiceContentWidget(),
          onTap: _palyVoiceUrl,
        ),
        if (_model.isCanEdit == true) _editButtonWidget(),
      ]),
    );
  }

  Widget _voiceContentWidget() {
    return Container(
      padding: EdgeInsets.only(top: 2),
      height: 42,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 8,
            width: 11,
            child: _angleWidget(),
          ),
          Container(
            width: 85,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: _contextBorderRadius(), color: Colors.white),
            child: Image.asset(
              'assets/images/icon-voice-Left.png',
            ),
          ),
          SizedBox(
            width: 7,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_model.isReadVoice != true)
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                      color: Color(0xFFE83333),
                      borderRadius: BorderRadius.circular(11 / 2)),
                ),
              SizedBox(
                height: 6,
              ),
              Text(
                '${_model.voiceTime??0}”',
                style: TextStyle(fontSize: 16, color: Color(0xFF777777)),
              )
            ],
          ),
        ],
      ),
    );
  }

  BorderRadius _contextBorderRadius() {
    if (_userType == UserType.MeType) {
      return BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10));
    } else {
      return BorderRadius.only(
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10));
    }
  }

  Color _textContentColor() {
    if (_userType == UserType.MeType) {
      return Color(0xFF849FDB);
    } else {
      return Colors.white;
    }
  }

  Color _textColor() {
    if (_userType == UserType.MeType) {
      return Colors.white;
    } else {
      return Color(0xFF888888);
    }
  }

  //头像
  Widget _headImageWidget() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45 / 2),
      ),
      child: CachedNetworkImage(
        imageUrl: _model.userModel.headImage ?? HomeListItem.Error_Image_URL,
        placeholder: (BuildContext context, String url) => CachedNetworkImage(
          imageUrl: HomeListItem.Error_Image_URL,
        ),
        errorWidget: (BuildContext context, String url, error) =>
            CachedNetworkImage(
          imageUrl: HomeListItem.Error_Image_URL,
        ),
      ),
    );
  }

  //编辑按钮
  Widget _editButtonWidget() {
    return GestureDetector(
      child: Row(
        children: [
          SizedBox(
            width: 12,
          ),
          Image.asset(
            'assets/images/btn_edit.png',
            width: 17,
            height: 17,
          )
        ],
      ),
      onTap: _editClick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainWidget();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // _videoController?.dispose();
    super.dispose();
  }
}

abstract class ConverseIetmDelegate {
  void updateModel(int index, ConverseModel model);
}
