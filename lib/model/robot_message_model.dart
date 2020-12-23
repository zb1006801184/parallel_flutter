class RobotMessageModel {
  int id;
  String robotName;
  String welcomes;
  String profile;
  String uniqueId;
  int applicationIndustry;
  String customAnswers;
  int identity;
  String headImgUrl;

  RobotMessageModel(
      {this.id,
      this.robotName,
      this.welcomes,
      this.profile,
      this.uniqueId,
      this.applicationIndustry,
      this.customAnswers,
      this.identity,
      this.headImgUrl});

  RobotMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    robotName = json['robotName'];
    welcomes = json['welcomes'];
    profile = json['profile'];
    uniqueId = json['uniqueId'];
    applicationIndustry = json['applicationIndustry'];
    customAnswers = json['customAnswers'];
    identity = json['identity'];
    headImgUrl = json['headImgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['robotName'] = this.robotName;
    data['welcomes'] = this.welcomes;
    data['profile'] = this.profile;
    data['uniqueId'] = this.uniqueId;
    data['applicationIndustry'] = this.applicationIndustry;
    data['customAnswers'] = this.customAnswers;
    data['identity'] = this.identity;
    data['headImgUrl'] = this.headImgUrl;
    return data;
  }
}
