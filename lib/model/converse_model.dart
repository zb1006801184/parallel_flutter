import 'package:video_player/video_player.dart';

class ConverseModel {
  int type; //0 文本消息  1图片消息  2语音消息  3视频消息  4列表消息 5超链接 6应用
  String content;
  int from; //0自己 1他人
  int id; //对话的id
  int robotId; //机器人id
  Map applicationVo; //应用
  bool isReadVoice; //是否读了语音消息  yes已读  no未读
  bool isCanEdit; //是否可以编辑
  int voiceTime;

  VideoPlayerController videoController; //视频播放器
  Future initializeVideoPlayerFuture;
  UserModel userModel;

  ConverseModel(
      {this.type,
      this.content,
      this.userModel,
      this.from,
      this.id,
      this.robotId,
      this.applicationVo,
      this.initializeVideoPlayerFuture,
      this.videoController,
      this.isReadVoice,
      this.isCanEdit,
      this.voiceTime,
      });

  ConverseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    content = json['content'];
    userModel = json['userModel'] != null
        ? new UserModel.fromJson(json['userModel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['content'] = this.content;
    if (this.userModel != null) {
      data['userModel'] = this.userModel.toJson();
    }
    return data;
  }
}

class UserModel {
  String headImage;
  String name;

  UserModel({this.headImage, this.name});

  UserModel.fromJson(Map<String, dynamic> json) {
    headImage = json['headImage'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['headImage'] = this.headImage;
    data['name'] = this.name;
    return data;
  }
}
