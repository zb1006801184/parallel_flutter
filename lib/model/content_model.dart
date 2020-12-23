import 'package:editor_2020_9/pages/content_library/model/contenr_industry_model.dart';
import 'package:video_player/video_player.dart';

class ContentModel {
  String title;
  String content;
  double voiceTime;
  String videoTime;
  bool isShowAddAnswer = true;
  List<ContentIndustryModel> typeList;
  List typeIdList;
  VideoPlayerController videoController;
  Future initializeVideoPlayerFuture;
  int robotId;
  int voiceNum = 0; //录音数量
  int imageNum = 0; //图片数量
  int videoNum = 0; //视频数量
  int applyNum = 0; //万能应用数量
  int linkNum = 0; //超链接数量

  ContentModel({
    this.title,
    this.content,
    this.voiceTime,
    this.videoTime,
    this.videoController,
    this.typeList,
    this.typeIdList,
    this.isShowAddAnswer,
    this.initializeVideoPlayerFuture,
    this.robotId,
    this.videoNum,
    this.imageNum,
    this.voiceNum,
    this.applyNum,
    this.linkNum,
  });

  ContentModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    voiceTime = json['voiceTime'];
    videoTime = json['videoTime'];
    typeList = json['typeList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['voiceTime'] = this.voiceTime;
    data['videoTime'] = this.videoTime;
    return data;
  }
}
