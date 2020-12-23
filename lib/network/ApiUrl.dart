class ApiUrl {
  // static const String BASE_URL = 'http://192.168.3.196:7040';

  static const String BASE_URL = 'http://robot.dtrobo.com/api'; //线上地址

  //文件地址
  static const String IMAGE_URL = 'http://diting-picture.ditingai.com/';

  //登录
  static const String LOGIN_URL = '/api-auth/oauth/mobile/token';

  //用户登陆信息
  static const String GET_USER_INFO = '/api-user/users/detail';

  //发送验证码
  static const String SENDN_CODE_LOGIN_URL =
      '/api-user/verification_code/login_code';

  //上传图片 七牛token
  static const String UPLOAD_IMAGE_URL = '/api-user/files/uploads';

  //获取内容库分类列表
  static const String GET_CONTENT_CLASS_LIST =
      '/api-robot/questions/type/page/';

  //获取内容库模板列表
  static const String GET_CONTENT_TEMPLATE_LIST =
      '/api-robot/questions/template/';

  //获取内容库模板列表
  //更改知识状态 发布/撤销api-robot/questions/{robotId}/{id}
  static const String ADD_ROBOT_CONTENT_URL = '/api-robot/questions';

  //分页获取问题列表
  static const String GET_CONTENT_PROBLEM_LIST = '/api-robot/questions/';

  //对话
  static const String ROBOT_CHAT_URL = '/api-robot/chats';

  //根据id获取机器人id
  //根据id删除机器人 /api-robot/robots/{robotId}
  static const String ROBOT_MESSAGE_URL = '/api-robot/robots/';

  //机器人会话唯一标识
  static const String ROBOT_UUID_URL = '/api-robot/chats/mark';

  /// 获取用户机器人列表 GET
  // static const String ROBOT_LIST = '/api-robot/robots/application_robots?pageSize=3';
  static const String ROBOT_LIST = '/api-robot/robots/current/';

  /// 获取行业分类列表 GET
  static const String CLASSIFY_LIST = '/api-user/industry/level';

  /// 创建机器人 POST
  static const String CREATE_ROBOT = '/api-robot/robots';

  //根据id批量删除问题
  static const String DELETE_QUESTIONS = '/api-robot/questions/batch/';

  //内容库创建分类
  //编辑内容库分类  api-robot/questions/type/{robotId}/{typeId}/{typeName}
  static const String POST_CREATE_TYPE = '/api-robot/questions/type';

  //根据id获取详情
  static const String GET_QUESTION_DETAIL_URL = '/api-robot/questions/';

  //选择机器人  /api-robot/robots/select/{robotId}
  static const String POST_SELECT_ROBOT = '/api-robot/robots/select/';
}
