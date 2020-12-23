
class RobotModelEntity {
  int id;
  String robotName;
  String welcomes;
  String profile;
  String uniqueId;
  dynamic applicationIndustry;
  dynamic customAnswers;
  int identity;
  dynamic headImgUrl;

  static RobotModelEntity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    RobotModelEntity robotModelEntityBean = RobotModelEntity();
    robotModelEntityBean.id = map['id'];
    robotModelEntityBean.robotName = map['robotName'];
    robotModelEntityBean.welcomes = map['welcomes'];
    robotModelEntityBean.profile = map['profile'];
    robotModelEntityBean.uniqueId = map['uniqueId'];
    robotModelEntityBean.applicationIndustry = map['applicationIndustry'];
    robotModelEntityBean.customAnswers = map['customAnswers'];
    robotModelEntityBean.identity = map['identity'];
    robotModelEntityBean.headImgUrl = map['headImgUrl'];
    return robotModelEntityBean;
  }

  Map toJson() => {
    "id": id,
    "robotName": robotName,
    "welcomes": welcomes,
    "profile": profile,
    "uniqueId": uniqueId,
    "applicationIndustry": applicationIndustry,
    "customAnswers": customAnswers,
    "identity": identity,
    "headImgUrl": headImgUrl,
  };
}