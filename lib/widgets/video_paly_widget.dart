import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPalyWidget extends StatefulWidget {
  String url;
  VideoPalyWidget({Key key,this.url}):super(key: key);

  @override
  _VideoPalyWidgetState createState() => _VideoPalyWidgetState();

  static void showVideoWidget(
      BuildContext context, 
      {String url}) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation) =>
            FadeTransition(
                opacity: animation,
                child: VideoPalyWidget(
                  url: url,
                ))));
  }

}

class _VideoPalyWidgetState extends State<VideoPalyWidget> {
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
        File(widget.url));
    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.connectionState == ConnectionState.done) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: AspectRatio(
                  // aspectRatio: 16 / 9,
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SizedBox(height: 30),
          RaisedButton(
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // If the video is paused, play it.
                  _controller.play();
                }
              });
            },
          )
        ],
      ),
    );
  }
}
