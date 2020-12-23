import 'dart:developer';

import 'package:editor_2020_9/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:xfvoice/xfvoice.dart';

class SpeechWidget extends StatefulWidget {
  Function callBack;
  SpeechWidget({Key key, this.callBack}) : super(key: key);
  @override
  _SpeechWidgetState createState() => _SpeechWidgetState();
  static Future<void> showSpeechWidget(
    BuildContext context,
    Function callBack,
  ) async {
    _push() {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) =>
              FadeTransition(
                  opacity: animation,
                  child: SpeechWidget(
                    callBack: callBack,
                  ))));
    }

    var microphoneState = await Permission.microphone.status;
    if (microphoneState.isUndetermined || microphoneState.isDenied) {
      await Permission.microphone.request().then((value) {
        if (value.isGranted) _push();
      });
    } else {
      _push();
    }
  }
}

class _SpeechWidgetState extends State<SpeechWidget> {
  Timer _timer;
  int _count = 0;
  XFJsonResult xfResult;
  String filePath = '';
  String result = '';
  bool isClose = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final voice = XFVoice.shared;

    // 请替换成你的appid
    voice.init(appIdIos: '5dd74091', appIdAndroid: '5dd740911');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    param.asr_ptt = '0'; //取消注释可去掉标点符号
    param.asr_audio_path = 'audio.pcm';
    param.result_type = 'json'; //可以设置plain
    final map = param.toMap();
    map['dwa'] = 'wpgs'; //设置动态修正，开启动态修正要使用json类型的返回格式
    voice.setParameter(map);
  }

  void _recongize() {
    var listen = XFVoiceListener(
        onVolumeChanged: (volume) {},
        onBeginOfSpeech: () {
          xfResult = null;
        },
        onResults: (String result, isLast, String filePath) {
          if (xfResult == null) {
            xfResult = XFJsonResult(result);
          } else {
            final another = XFJsonResult(result);
            xfResult.mix(another);
          }
          if (result.length > 0 && isLast == true) {
            filePath = filePath.toString();
            result = xfResult.resultText().toString();
            Navigator.of(context).pop();
            widget.callBack(result, filePath);
          }
        },
        onEndOfSpeech: () {},
        onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
          setState(() {});
        });

    XFVoice.shared.start(listener: listen);
  }

  void _recongizeOver() {
    XFVoice.shared.stop();
  }

  void _pressUp() async {
    log('================结束==================');
    _timer.cancel();
    isClose = true;
    _recongizeOver();
  }

  //###########################actions###########################
  void _addTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
      _count++;
      setState(() {});
      if (_count == 60) {
        t.cancel();
      }
    });
  }

//###########################widgets###########################
//中间按钮
  Widget _centerButtonWidget() {
    return GestureDetector(
      child: Container(
        height: 98,
        width: 98,
        child: Stack(
          children: [
            Container(
              width: 98,
              height: 98,
              child: Image.asset(
                'assets/images/icon_voice.png',
                fit: BoxFit.fill,
              ),
            ),
            linearProgressIndicatorWidget(),
          ],
        ),
      ),
      onLongPressUp: _pressUp,
      onTapDown: (d) {
        //手指按上
        _addTimer();
        _recongize();
      },
      onTap: () {},
      onTapUp: (d){
        _pressUp();
      },
    );
  }

//进度条
  Widget linearProgressIndicatorWidget() {
    return Center(
      child: Container(
        width: 98 - 16.0,
        height: 98 - 16.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey.withOpacity(0.8),
          valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.5)),
          value: _count / 60,
          strokeWidth: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Container(
          width: Global.ksWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _centerButtonWidget(),
              SizedBox(
                height: 10,
              ),
              Text(
                '按住说话',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(
                height: 134,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    super.dispose();
  }
}
