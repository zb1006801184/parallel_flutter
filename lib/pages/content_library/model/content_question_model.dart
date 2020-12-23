class ContentQuestionModel {
  int _id;
  String _question;
  String _scene;
  String _createdTime;
  String _updatedTime;
  String _typeName;
  int _replyStrategy;
  int _status; //0未发布 1已发布
  bool _isOffstage = false; //是否展开附件
  List<Answers> _answers;

  ContentQuestionModel(
      {int id,
      String question,
      String scene,
      String createdTime,
      String updatedTime,
      String typeName,
      int replyStrategy,
      int status,
      bool isOffstage,
      List<Null> similarQuestion,
      List<Answers> answers}) {
    this._id = id;
    this._question = question;
    this._scene = scene;
    this._createdTime = createdTime;
    this._updatedTime = updatedTime;
    this._typeName = typeName;
    this._replyStrategy = replyStrategy;
    this._status = status;
    this._isOffstage = isOffstage;
    this._answers = answers;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get question => _question;

  set question(String question) => _question = question;

  String get scene => _scene;

  set scene(String scene) => _scene = scene;

  String get createdTime => _createdTime;

  set createdTime(String createdTime) => _createdTime = createdTime;

  String get updatedTime => _updatedTime;

  set updatedTime(String updatedTime) => _updatedTime = updatedTime;

  String get typeName => _typeName;

  set typeName(String typeName) => _typeName = typeName;

  int get replyStrategy => _replyStrategy;

  set replyStrategy(int replyStrategy) => _replyStrategy = replyStrategy;

  int get status => _status;

  set status(int status) => _status = status;

  bool get isOffstage => _isOffstage;

  set isOffstage(bool isOffstage) => _isOffstage = isOffstage;

  List<Answers> get answers => _answers;

  set answers(List<Answers> answers) => _answers = answers;

  ContentQuestionModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _question = json['question'];
    _scene = json['scene'];
    _createdTime = json['createdTime'];
    _updatedTime = json['updatedTime'];
    _typeName = json['typeName'];
    _replyStrategy = json['replyStrategy'];
    _status = json['status'];

    if (json['answers'] != null) {
      _answers = new List<Answers>();
      json['answers'].forEach((v) {
        _answers.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['question'] = this._question;
    data['scene'] = this._scene;
    data['createdTime'] = this._createdTime;
    data['updatedTime'] = this._updatedTime;
    data['typeName'] = this._typeName;
    data['replyStrategy'] = this._replyStrategy;
    data['status'] = this._status;
    data['isOffstage'] = this._isOffstage;

    if (this._answers != null) {
      data['answers'] = this._answers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int _id;
  String _answer;
  String _imgUrl;
  String _audioUrl;
  String _videoUrl;
  String _hyperlinkUrl;
  ApplicationVo _applicationVo;

  Answers(
      {int id,
      String answer,
      String imgUrl,
      String audioUrl,
      String videoUrl,
      String hyperlinkUrl,
      ApplicationVo applicationVo}) {
    this._id = id;
    this._answer = answer;
    this._imgUrl = imgUrl;
    this._audioUrl = audioUrl;
    this._videoUrl = videoUrl;
    this._hyperlinkUrl = hyperlinkUrl;
    this._applicationVo = applicationVo;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get answer => _answer;

  set answer(String answer) => _answer = answer;

  String get imgUrl => _imgUrl;

  set imgUrl(String imgUrl) => _imgUrl = imgUrl;

  String get audioUrl => _audioUrl;

  set audioUrl(String audioUrl) => _audioUrl = audioUrl;

  String get videoUrl => _videoUrl;

  set videoUrl(String videoUrl) => _videoUrl = videoUrl;

  String get hyperlinkUrl => _hyperlinkUrl;

  set hyperlinkUrl(String hyperlinkUrl) => _hyperlinkUrl = hyperlinkUrl;

  ApplicationVo get applicationVo => _applicationVo;

  set applicationVo(ApplicationVo applicationVo) =>
      _applicationVo = applicationVo;

  Answers.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _answer = json['answer'];
    _imgUrl = json['imgUrl'];
    _audioUrl = json['audioUrl'];
    _videoUrl = json['videoUrl'];
    _hyperlinkUrl = json['hyperlinkUrl'];
    _applicationVo = json['applicationVo'] != null
        ? new ApplicationVo.fromJson(json['applicationVo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['answer'] = this._answer;
    data['imgUrl'] = this._imgUrl;
    data['audioUrl'] = this._audioUrl;
    data['videoUrl'] = this._videoUrl;
    data['hyperlinkUrl'] = this._hyperlinkUrl;
    if (this._applicationVo != null) {
      data['applicationVo'] = this._applicationVo.toJson();
    }
    return data;
  }
}

class ApplicationVo {
  int _applicationId;
  String _applicationName;
  String _mobile;
  String _description;
  String _price;

  ApplicationVo(
      {int applicationId,
      String applicationName,
      String mobile,
      String description,
      String price}) {
    this._applicationId = applicationId;
    this._applicationName = applicationName;
    this._mobile = mobile;
    this._description = description;
    this._price = price;
  }

  int get applicationId => _applicationId;

  set applicationId(int applicationId) => _applicationId = applicationId;

  String get applicationName => _applicationName;

  set applicationName(String applicationName) =>
      _applicationName = applicationName;

  String get mobile => _mobile;

  set mobile(String mobile) => _mobile = mobile;

  String get description => _description;

  set description(String description) => _description = description;

  String get price => _price;

  set price(String price) => _price = price;

  ApplicationVo.fromJson(Map<String, dynamic> json) {
    _applicationId = json['applicationId'];
    _applicationName = json['applicationName'];
    _mobile = json['mobile'];
    _description = json['description'];
    _price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicationId'] = this._applicationId;
    data['applicationName'] = this._applicationName;
    data['mobile'] = this._mobile;
    data['description'] = this._description;
    data['price'] = this._price;
    return data;
  }
}
