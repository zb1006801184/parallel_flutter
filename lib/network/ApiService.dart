import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:editor_2020_9/model/robot_message_model.dart';
import 'package:editor_2020_9/network/ApiUrl.dart';
import 'package:editor_2020_9/network/BaseResult.dart';
import 'package:editor_2020_9/pages/content_library/model/contenr_industry_model.dart';
import 'package:editor_2020_9/pages/content_library/model/content_question_model.dart';
import 'package:editor_2020_9/pages/login/model/login_info_model.dart';
import 'package:editor_2020_9/pages/login/model/user_info_model.dart';
import 'package:editor_2020_9/utils/data_name_unitls.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/sp_util.dart';
import 'package:editor_2020_9/utils/time_util.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:flutter/material.dart';

import 'HttpUtils.dart';

class ApiService {
  //获取今日新闻
  // static Future<NewsModel> getTodayNews() async {
  //   Response response =
  //       await HttpUtils().request(ApiUrl.TODAYNEWS_URL, method: HttpUtils.GET);
  //   if (response != null) {
  //     var responseData = jsonDecode(response.data);
  //     if (responseData == null) {
  //       return null;
  //     }
  //     return NewsModel.fromJson(responseData);
  //   } else {
  //     return null;
  //   }
  // }

  ///登录
  static Future<LoginInfoModel> getloginRequest(
      String mobile, String code) async {
    String url = ApiUrl.LOGIN_URL +
        "?mobile=" +
        mobile +
        "&verificationCode=" +
        code +
        '&projectCode=2';
    print("登录 url" + url);
    Response response =
        await HttpUtils(headers: {"Authorization": "Basic YXBwOmFwcA=="})
            .request(url, method: HttpUtils.POST);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    // print("登录 url" + respCode.toString());
    if (respCode == 200) {
      LoginInfoModel data = LoginInfoModel.fromJson(responseData["data"]);
      // getUserInfo(data.accessToken);
      return data;
    } else if (respCode == 30004) {
      _toastView("帐户或验证码不正确");
      return null;
    } else {
      _toastView(responseData);
    }
  }

  ///发送验证码
  static Future<dynamic> sendCodeRequest(String mobile) async {
    String url =
        ApiUrl.SENDN_CODE_LOGIN_URL + "?mobile=" + mobile + "&projectCode=2";
    Response response = await HttpUtils().request(url, method: HttpUtils.GET);
    print("发送验证码" + response.toString());

    var responseData = jsonDecode(response.data);
    return responseData;
  }

  ///获取用户信息
  static Future<UserInfoModel> getUserInfo(String token) async {
    Response response =
        await HttpUtils(headers: {"Authorization": "Bearer ${token}"})
            .request(ApiUrl.GET_USER_INFO, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    print("用户信息" + response.toString());
    UserInfoModel data;
    if (responseData["resp_code"] == 200) {
      data = UserInfoModel.fromJson(responseData["data"]);
      SpUtil.setInt(DataName.USERROBOTID, data.selectedRobotId);
      Global.userInfoModel = data;
    }
    return data;
  }

  //上传图片
  static Future<dynamic> uploadImageRequest(FormData params) async {
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer ${Global.tokenModel.accessToken}"
    }).uploadFile(ApiUrl.UPLOAD_IMAGE_URL, data: params);
    if (response != null) {
      var responseData = response.data;
      return responseData['data']['urls'][0] ?? null;
    } else {
      return null;
    }
  }

  //获取七牛token

  static Future<dynamic> getQiniuTokenRequest() async {
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer ${Global.tokenModel.accessToken}"
    }).request(ApiUrl.UPLOAD_IMAGE_URL, method: HttpUtils.GET);
    if (response != null) {
      var responseData = jsonDecode(response.data);
      return responseData['data'] ?? null;
    } else {
      return null;
    }
  }

  ///获取内容库问题列表
  static Future<List<ContentQuestionModel>> getContnetTemplateRequest(
      int pageNum, int type) async {
    String url = ApiUrl.GET_CONTENT_PROBLEM_LIST +
        "${Global.userInfoModel.selectedRobotId}?pageNum=" +
        pageNum.toString() +
        "&pageSize=10&typeId=" +
        type.toString();
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.GET);
    print("当前数据数据" + response.data.toString());
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      var data = responseData['data'];
      Global.questionPage = data["pages"];
      List records = data["records"];
      List<ContentQuestionModel> result = [];
      records.forEach((element) {
        result.add(ContentQuestionModel.fromJson(element));
      });
      return result;
    } else {
      _toastView(responseData);
    }
  }

  ///获取七牛云视频时长
  static Future<dynamic> getQN(String url) async {
    Response response =
        await HttpUtils(headers: {}).request(url, method: HttpUtils.GET);
    if (response != null) {
      var responseData = jsonDecode(response.data);
      List list = responseData['streams'];
      var streams = list[0];
      var duration = streams["duration"];
      return duration;
    } else {
      return null;
    }
  }

  ///获取内容库分类列表
  static Future<List<ContentIndustryModel>> getContnetClassRequest(
      int pageNum, Function error) async {
    String url = ApiUrl.GET_CONTENT_CLASS_LIST +
        Global.userInfoModel.selectedRobotId.toString() +
        "/0" +
        "?pageNum=" +
        pageNum.toString() +
        "&pageSize=10";
    print("当前token" + Global.tokenModel.accessToken);
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      var dataa = responseData['data'];
      Global.industryPage = dataa["pages"];
      List data = dataa['records'];
      if (data.isEmpty) {
        return null;
      } else {
        List<ContentIndustryModel> result = [];
        data.forEach((element) {
          result.add(ContentIndustryModel.fromJson(element));
        });
        return result;
      }
    } else if (respCode == 10105) {
      error(respCode);
      return null;
    } else {
      _toastView(responseData);
    }
  }

  static Future<dynamic> deleteQuestions(int ids) async {
    String url = ApiUrl.DELETE_QUESTIONS +
        Global.userInfoModel.selectedRobotId.toString() +
        "?ids=" +
        ids.toString();
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.DELETE);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      _toastView("删除问题成功");
    } else {
      _toastView(responseData);
    }
  }

//添加问答
  static Future<dynamic> addRobotContentRequest(Map params) async {
    String url = ApiUrl.ADD_ROBOT_CONTENT_URL;
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: params, method: HttpUtils.POST);
    var responseData = jsonDecode(response?.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      _toastView('请求成功');
      return responseData;
    }
    if (respCode == 10202) {
      _toastView('该问题已存在，请重新输入');
    } else {
      _toastView(responseData);
    }
    return null;
  }

//编辑问答
  static Future<dynamic> editRobotContentRequest(Map params) async {
    String url = ApiUrl.ADD_ROBOT_CONTENT_URL;
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: params, method: HttpUtils.PUT);
    var responseData = jsonDecode(response?.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      _toastView('请求成功');
      return responseData;
    }
    if (respCode == 10202) {
      _toastView('该问题已存在，请重新输入');
    } else {
      _toastView(responseData);
    }
    return null;
  }

  //对话接口
  static Future<dynamic> robotChatContentRequest(Map params) async {
    String url = ApiUrl.ROBOT_CHAT_URL;
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: params, method: HttpUtils.POST);
    var responseData = jsonDecode(response?.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      // _toastView('请求成功');
      return responseData;
    }
    if (respCode == 10202) {
    } else {
      _toastView(responseData);
    }
    return null;
  }

//获取默认机器人信息
  static Future<RobotMessageModel> getRobotMessageRequest(
      String robotId) async {
    String url = ApiUrl.ROBOT_MESSAGE_URL + robotId;
    Response response = await HttpUtils(headers: {
      // "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      RobotMessageModel model =
          RobotMessageModel.fromJson(responseData['data']);
      return model;
    } else {
      _toastView(responseData);
    }
    return null;
  }

  //删除机器人信息
  static Future<dynamic> deleteRobotInfo(String robotId) async {
    String url = ApiUrl.ROBOT_MESSAGE_URL + robotId;
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.DELETE);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      _toastView("删除成功");
      return respCode;
    } else if (respCode == 10107) {
      _toastView("该机器人被使用中不能被删除");
    } else {
      _toastView(responseData);
    }
  }

  //获取会话唯一标识
  static Future<dynamic> getRobotUUIDRequest() async {
    String url = ApiUrl.ROBOT_UUID_URL;
    Response response = await HttpUtils(headers: {
      // "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      return responseData;
    } else {
      _toastView(responseData);
    }
    return null;
  }

  ///获取机器人列表
  static Future<dynamic> getRobotList(dynamic parentId) async {
    String url = ApiUrl.ROBOT_LIST + parentId.toString();
    print("获取机器人列表-url:" + url);
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    print("获取机器人列表-respCode:" + respCode.toString());
    if (respCode == 200) {
      BaseResult result = BaseResult.fromMap(json.decode(response.data));
      var records = result.data["robots"];
      print("获取机器人列表-respCode:" + records.toString());

      return records;
    }
  }

  /// 获取行业分类列表
  static Future<dynamic> getClassifyList() async {
    String url = ApiUrl.CLASSIFY_LIST;
    print("获取行业分类列表-url:" + url);
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    print("获取行业分类列表-respCode:" + respCode.toString());
    if (respCode == 200) {
      BaseResult result = BaseResult.fromMap(json.decode(response.data));
      var records = result.data;
      return records;
    }
  }

  /// 创建机器人
  static Future<dynamic> createRobot(params) async {
    String url = ApiUrl.CREATE_ROBOT;
    print("创建机器人-url:" + url);
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: params, method: HttpUtils.POST);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    print("创建机器人-responseData:" + responseData.toString());
    return respCode;
  }

  /// 选择机器人
  static Future<dynamic> selectRobot(int robotId) async {
    String url = ApiUrl.POST_SELECT_ROBOT + robotId.toString();
    print("选择机器人-url:" + url);
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: null, method: HttpUtils.POST);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    print("选择机器人-responseData:" + responseData.toString());
    if (responseData == 200) {
      _toastView("切换成功");
    }
    return respCode;
  }

  /// 创建内容库分类
  static Future<dynamic> createContentType(params) async {
    String url = ApiUrl.POST_CREATE_TYPE;
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: params, method: HttpUtils.POST);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      _toastView("添加分类成功");
    } else if (respCode == 10202) {
      _toastView("该分类已存在");
    } else {
      _toastView(responseData);
    }
    return responseData;
  }

  /// 编辑内容库分类
  static Future<dynamic> editContentType(String typeName, int typeId) async {
    String url = ApiUrl.POST_CREATE_TYPE +
        "/${Global.userInfoModel.selectedRobotId}/" +
        typeId.toString() +
        "/" +
        typeName;
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: null, method: HttpUtils.PUT);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      _toastView("修改成功");
    } else {
      _toastView(responseData);
    }
    return responseData;
  }

  /// 更改内容库状态 发布/撤销
  static Future<dynamic> updateContentState(int id, int action) async {
    String url = ApiUrl.ADD_ROBOT_CONTENT_URL +
        "/${Global.userInfoModel.selectedRobotId}/" +
        "?action=${action.toString()}&ids=${id.toString()}";
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: null, method: HttpUtils.PUT);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      _toastView("更新状态成功");
    } else {
      _toastView(responseData);
    }
    return responseData;
  }

  //获取机器人详情
  static Future<dynamic> getRobotDetailRequest({
    int id,
    int robotId,
  }) async {
    String url =
        ApiUrl.GET_QUESTION_DETAIL_URL + "/${robotId}/" + id.toString();
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, data: null, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      return responseData;
    } else {
      _toastView(responseData);
    }
    return null;
  }

  ///根据机器人id 获取内容库分类列表
  static Future<List<ContentIndustryModel>> getContnetClassWithIdRequest(
      int pageNum,
      {String robotId}) async {
    String url = ApiUrl.GET_CONTENT_CLASS_LIST +
        "${robotId}" +
        "/0" +
        "?pageNum=" +
        pageNum.toString() +
        "&pageSize=10";
    print("当前token" + Global.tokenModel.accessToken);
    Response response = await HttpUtils(headers: {
      "Authorization": "Bearer " + Global.tokenModel.accessToken
    }).request(url, method: HttpUtils.GET);
    var responseData = jsonDecode(response.data);
    int respCode = responseData["resp_code"];
    if (respCode == 200) {
      var dataa = responseData['data'];
      Global.industryPage = dataa["pages"];
      List data = dataa['records'];
      List<ContentIndustryModel> result = [];
      data.forEach((element) {
        result.add(ContentIndustryModel.fromJson(element));
      });
      return result;
    } else if (respCode == 10105) {
      // error(respCode);
      return null;
    } else {
      _toastView(responseData);
    }
  }

  ///ToastView
  static void _toastView(responseData) {
    ToastView(
      title: responseData.toString(),
    ).showMessage();
  }
}
