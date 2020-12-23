import 'package:editor_2020_9/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;

  VideoPage({
    Key key,
    this.videoUrl,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPageState();
  }
}

class VideoPageState extends State<VideoPage> with WidgetsBindingObserver {
  VideoPlayerController _controller;
  int position = 0;
  double height = 0;
  bool fullScreen = false;
  bool hideAppBar = false;
  bool hideControllBar = false;
  String tips = '缓冲中...';
  IconData _icons = Icons.pause_circle_outline;
  double dy = 0;
  String _videoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        height: height,
        child: _controller.value.initialized
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: InkWell(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          // 滑动控制音量、亮度、进度等操作
                          GestureDetector(
                            onVerticalDragStart: (details) {
                              dy = 0;
                            },
                            onVerticalDragUpdate: (details) {
                              dy += details.delta.dy;
                              print('${details.delta.dy}  :  $dy');
                              print(dy / MediaQuery.of(context).size.height);
                              _controller.setVolume(1);
                            },
                            onVerticalDragEnd: (details) {},
                            child: VideoPlayer(_controller),
                          ),
                          Text(
                            tips,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          hideControllBar = !hideControllBar;
                        });
                      },
                    ),
                  ),
                  // 播放器顶部标题栏
                  Align(
                    alignment: Alignment.topCenter,
                    child: Offstage(
                      offstage: hideControllBar,
                      child: Container(
                        color: Colors.black38,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (fullScreen) {
                                    height = 200;
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.portraitUp,
                                      DeviceOrientation.portraitUp,
                                    ]);
                                    SystemChrome.setEnabledSystemUIOverlays([
                                      SystemUiOverlay.top,
                                      SystemUiOverlay.bottom
                                    ]);
                                    hideAppBar = false;
                                  } else {
                                    print('关闭');
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  // 播放器底部控制栏
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Offstage(
                      offstage: hideControllBar,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.black54,
                        child: Row(children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                  _icons = Icons.play_circle_outline;
                                } else {
                                  _controller.play();
                                  _icons = Icons.pause_circle_outline;
                                }
                              });
                            },
                            child: Icon(
                              _icons,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            TimeUtils.getCurrentPosition(position),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // 进度条
                          Expanded(
                              child: LinearProgressIndicator(
                            value: TimeUtils.getProgress(
                                position, _controller.value.duration.inSeconds),
                            backgroundColor: Colors.black87,
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            TimeUtils.getCurrentPosition(
                                _controller.value.duration.inSeconds),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            child: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 30,
                            ),
                            onTap: () {
                              fullOrMin();
                            },
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                child: Text(
                  tips,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
      ),
    );
  }

  void fullOrMin() {
    setState(() {
      if (fullScreen) {
        height = 200;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitUp,
        ]);
        SystemChrome.setEnabledSystemUIOverlays(
            [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        hideAppBar = false;
      } else {
        hideAppBar = true;
        height = MediaQuery.of(context).size.height;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
      fullScreen = !fullScreen;
    });
  }

  @override
  void initState() {
    super.initState();
    _videoUrl = widget.videoUrl;
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.network(
        _videoUrl);
    _controller.addListener(() {
      if (_controller.value.hasError) {
        print(_controller.value.errorDescription);
        setState(() {
          tips = '播放出错';
        });
      } else if (_controller.value.initialized) {
        setState(() {
          position = _controller.value.position.inSeconds;
          tips = '';
        });
      } else if (_controller.value.isBuffering) {
        setState(() {
          tips = '缓冲中...';
        });
      }
    });
    _controller.initialize().then((_) {
      setState(() {
        _controller.play();
        _controller.setVolume(1);
      });
    });
    _controller.setLooping(true);
    height = 200;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
  }
}
