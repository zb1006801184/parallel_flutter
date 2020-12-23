class UserInfoModel {
  String _username;
  String _nickname;
  String _headImgUrl;
  String _mobile;
  int _sex;
  int _selectedRobotId;
  String _robotName;

  UserInfoModel({
    String username,
    String nickname,
    String headImgUrl,
    String mobile,
    int sex,
    int selectedRobotId,
    String robotName,
  }) {
    this._username = username;
    this._nickname = nickname;
    this._headImgUrl = headImgUrl;
    this._mobile = mobile;
    this._sex = sex;
    this._selectedRobotId = selectedRobotId;
    this._robotName = robotName;
  }

  String get username => _username;

  set username(String username) => _username = username;

  String get nickname => _nickname;

  set nickname(String nickname) => _nickname = nickname;

  String get headImgUrl => _headImgUrl;

  set headImgUrl(String headImgUrl) => _headImgUrl = headImgUrl;

  String get mobile => _mobile;

  set mobile(String mobile) => _mobile = mobile;

  int get sex => _sex;

  set sex(int sex) => _sex = sex;

  int get selectedRobotId => _selectedRobotId;

  set selectedRobotId(int selectedRobotId) =>
      _selectedRobotId = selectedRobotId;

  String get robotName => _robotName;

  set robotName(String robotName) =>
      _robotName = robotName;

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _nickname = json['nickname'];
    _headImgUrl = json['headImgUrl'];
    _mobile = json['mobile'];
    _sex = json['sex'];
    _selectedRobotId = json['selectedRobotId'];
    _robotName = json['robotName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this._username;
    data['nickname'] = this._nickname;
    data['headImgUrl'] = this._headImgUrl;
    data['mobile'] = this._mobile;
    data['sex'] = this._sex;
    data['selectedRobotId'] = this._selectedRobotId;
    data['robotName'] = this._robotName;
    return data;
  }
}
