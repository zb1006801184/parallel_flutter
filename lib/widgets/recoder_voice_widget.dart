import 'package:editor_2020_9/utils/public_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record/index.dart';

class RecoderVoiceWidget extends StatefulWidget {
  Function callBackHandler;
  RecoderVoiceWidget({Key key, this.callBackHandler}) : super(key: key);
  @override
  _RecoderVoiceWidgetState createState() => _RecoderVoiceWidgetState();

  static void showRecoderVoiceWidget(
      BuildContext context, Function callBackHandler,
      {String message}) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation) =>
            FadeTransition(
                opacity: animation,
                child: RecoderVoiceWidget(
                  callBackHandler: callBackHandler,
                ))));
  }
}

class _RecoderVoiceWidgetState extends State<RecoderVoiceWidget> {
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();
  bool isRecoder = false; //是否正在录音
  String filePath = "";
  String voiceTime = '';
  bool isCallBack = false;
  @override
  void initState() {
    super.initState();

    ///初始化方法的监听
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    /// 开始录制或结束录制的监听
    recordPlugin.response.listen((data) {
      if (data.msg == "onStop") {
        ///结束录制时会返回录制文件的地址方便上传服务器
        filePath = data.path;
        voiceTime = data.audioTimeLength.toString();
        if (isCallBack == true) {
          widget.callBackHandler(filePath, voiceTime ?? 0.0);
          Navigator.of(context).pop();
        }
        print("onStop  时长 " + voiceTime);
      } else if (data.msg == "onStart") {
        // print("onStart --");
      } else {
        // print("--" + data.msg);
      }
    });

    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    recordPlugin.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg);
    });

    recordPlugin.responsePlayStateController.listen((data) {
      // print("播放路径   " + data.playPath);
      // print("播放状态   " + data.playState);
    });

    recordPlugin.init();
  }

  void _colseRecoderClick() {
    if (filePath.length >= 1 || isRecoder == true) {
      PublicTool.showMessageBox(context, content: '是否保存录音？',
          onOkBtnTap: (e) {
        _didRecoderClick();
      });
      return;
    }
    recordPlugin.stop();
    Navigator.of(context).pop();
  }

  void _recoderClick() {
    if (isRecoder == true) {
      recordPlugin.stop();
    } else {
      recordPlugin.start();
    }
    setState(() {
      isRecoder = !isRecoder;
    });
  }

  void _didRecoderClick() async {
    if (isRecoder == true) {
      isCallBack = true;
      await recordPlugin.stop();
    } else {
      widget.callBackHandler(filePath, voiceTime ?? 0.0);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          child: Center(
            child: Container(
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFFE3E3E3),
                      offset: Offset(-1, -1),
                      blurRadius: 12,
                      spreadRadius: 1.0),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 52),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Image.asset('assets/images/icon_close.png'),
                    onTap: _colseRecoderClick,
                  ),
                  GestureDetector(
                    child: Image.asset(isRecoder == false
                        ? 'assets/images/btn_sound_recording.png'
                        : 'assets/images/btn_sound_start.png'),
                    onTap: _recoderClick,
                  ),
                  GestureDetector(
                    child: Image.asset('assets/images/icon_determine.png'),
                    onTap: _didRecoderClick,
                  ),
                ],
              ),
            ),
          ),
          onTap: () {},
        ),
      ),
      onTap: _colseRecoderClick,
    );
  }
}
