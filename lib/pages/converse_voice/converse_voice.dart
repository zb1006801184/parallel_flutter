import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "7c999b815033419191ce579f584a0936";
const token =
    "0067c999b815033419191ce579f584a0936IADBN/QLbjn6frcOB5dq21HT3T4d72odCWdeghVgE78X3op+KioAAAAAEACLUtgwoqHZXwEAAQCiodlf";
const channelId1 = "flutter";
const uid = 3;
const stringUid = "123";

class ConverseVoicePage extends StatefulWidget {
  RtcEngine _engine = null;

  @override
  _ConverseVoicePageState createState() => _ConverseVoicePageState();
}

class _ConverseVoicePageState extends State<ConverseVoicePage> {
  String channelId = channelId1;
  //是否加入聊天室
  bool isJoined = false,
      //是否打开麦克风
      openMicrophone = true,
      //外音 = true   听筒模式 = false
      enableSpeakerphone = true,
      playEffect = false;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: channelId);
    this._initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    widget._engine?.destroy();
  }

  _initEngine() async {
    widget._engine = await RtcEngine.create(appId);
    this._addListeners();

    await widget._engine.enableAudio();
    await widget._engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await widget._engine.setClientRole(ClientRole.Broadcaster);
  }

  _addListeners() {
    widget._engine?.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      log('joinChannelSuccess ${channel} ${uid} ${elapsed}');
      setState(() {
        isJoined = true;
      });
    }, leaveChannel: (stats) {
      log('leaveChannel ${stats.toJson()}');
      // setState(() {
      //   isJoined = false;
      // });
      Navigator.of(context).pop();
    }, error: (e) {
      log(e.toString());
    }));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    await widget._engine?.joinChannel(token, channelId, null, uid);
  }

  _leaveChannel() async {
    await widget._engine?.leaveChannel();
  }

  _switchMicrophone() {
    widget._engine?.enableLocalAudio(!openMicrophone)?.then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    })?.catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    widget._engine?.setEnableSpeakerphone(!enableSpeakerphone)?.then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    })?.catchError((err) {
      log('setEnableSpeakerphone $err');
    });
  }

  _switchEffect() async {
    if (playEffect) {
      widget._engine?.stopEffect(1)?.then((value) {
        setState(() {
          playEffect = false;
        });
      })?.catchError((err) {
        log('stopEffect $err');
      });
    } else {
      widget._engine
          ?.playEffect(
              1,
              await RtcEngineExtension.getAssetAbsolutePath(
                  "assets/Sound_Horizon.mp3"),
              -1,
              1,
              1,
              100,
              true)
          ?.then((value) {
        setState(() {
          playEffect = true;
        });
      })?.catchError((err) {
        log('playEffect $err');
      });
    }
  }

  //####################actions########################
  void _buttonClick(String title) {
    if (title == '接听') {
      isJoined ? _leaveChannel() : _joinChannel();
    } else if (title == '取消') {
      _leaveChannel();
    }
    print(title);
  }

//####################widgets########################
  Widget _mainWidget() {
    return Stack(
      children: [
        Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Channel ID'),
              onChanged: (text) {
                setState(() {
                  channelId = text;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    onPressed:
                        isJoined ? this._leaveChannel : this._joinChannel,
                    child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
                  ),
                )
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                onPressed: this._switchMicrophone,
                child: Text('Microphone ${openMicrophone ? 'on' : 'off'}'),
              ),
              RaisedButton(
                onPressed: this._switchSpeakerphone,
                child: Text(enableSpeakerphone ? 'Speakerphone' : 'Earpiece'),
              ),
              RaisedButton(
                onPressed: this._switchEffect,
                child: Text('${playEffect ? 'Stop' : 'Play'} effect'),
              ),
            ],
          ),
        )
      ],
    );
  }

//头像/昵称
  Widget _topWidget() {
    return Container(
      margin: EdgeInsets.only(top: 98),
      child: Column(
        children: [
          Container(
            width: 98,
            height: 98,
            color: Colors.red,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            '苏宁小助手',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

//底部widgets 呼叫中
  Widget _bottomCallWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 83),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: _imageWithText(
                      title: '拒绝', imageUrl: 'assets/images/jujue.png'),
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: _imageWithText(
                      title: '接听', imageUrl: 'assets/images/jieting.png'),
                ),
              )),
        ],
      ),
    );
  }

//底部widgets 对话中
  Widget _bottomConverseWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 83),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Center(
                      child: _imageWithText(
                          title: '静音',
                          imageUrl: 'assets/images/jingyin_select.png'),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Center(
                      child: _imageWithText(
                          title: '免提',
                          imageUrl: 'assets/images/mianti_select.png'),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 11,
          ),
          Text(
            '00:18',
            style: TextStyle(color: Colors.white),
          ),
          _imageWithText(title: '取消', imageUrl: 'assets/images/dianhua.png'),
        ],
      ),
    );
  }

//图片带文字

  Widget _imageWithText({String title = '', String imageUrl}) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              child: Image.asset(imageUrl),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        _buttonClick(title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.titleBar(context, '',
          color: Colors.black, brightness: Brightness.dark, showShadow: false),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topWidget(),
          if (isJoined == false) _bottomCallWidget(),
          if (isJoined == true) _bottomConverseWidget(),
        ],
      ),
    );
  }
}
