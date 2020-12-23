import 'package:editor_2020_9/model/content_model.dart';
import 'package:editor_2020_9/model/converse_model.dart';
import 'package:editor_2020_9/pages/content_library/model/contenr_industry_model.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class PublicUnitls {
//###############添加问答的业务处理################

  static bool isCanDelete(List dataList, int index) {
    ContentModel model = dataList[index];
    if (model.title == '答案：' && calculateInt(dataList, model.title) > 1) {
      return true;
    }
    if (model.title == '一段录音' ||
        model.title == '图片' ||
        model.title == '电话应用' ||
        model.title == '超链接' ||
        model.title == '视频') {
      return true;
    }
    return false;
  }

  static int calculateInt(List dataList, String title) {
    int count = 0;
    for (ContentModel item in dataList) {
      if (item.title == title) {
        count += 1;
      }
    }
    return count;
  }

  //返回添加内容库的参数

  static Future<Map> submitParams(List dataList,
      {String title, int robotId}) async {
    Map params = {
      'robotId': robotId,
      'skillId': null,
      'tag': null,
      'similarQuestion': null,
      'replyStrategy': null,
      'scene': '',
      'typeIds': null,
    };
    if (title == '保存草稿') {
      params['status'] = false;
    } else {
      params['status'] = true;
    }
    List answerDTOS = [];
    int weights = 0;
    for (var item in dataList) {
      ContentModel model = item;
      if (model.title == '问题分类：') {
        List typeList = [];
        for (ContentIndustryModel item in model.typeList) {
          if (item.id != null) {
            typeList.add(item.id);
          }
        }
        params['typeIds'] = typeList;
      }
      if (model.title == '问题：') {
        params['question'] = model.content;
      }
      if (model.title == '答案：') {
        answerDTOS.add({'answer': model.content, 'weights': weights});
        weights += 1;
      }
      if (model.title == '一段录音') {
        answerDTOS.add({'audioUrl': model.content, 'weights': weights});
        weights += 1;
      }
      if (model.title == '视频') {
        answerDTOS.add({'videoUrl': model.content, 'weights': weights});
        weights += 1;
      }
      if (model.title == '图片') {
        answerDTOS.add({'imgUrl': model.content, 'weights': weights});
        weights += 1;
      }
      if (model.title == '电话应用') {
        answerDTOS.add({
          'application': {'mobile': model.content, 'applicationId': '1'},
          'weights': weights
        });
        weights += 1;
      }
      if (model.title == '超链接') {
        answerDTOS.add({'hyperlinkUrl': model.content, 'weights': weights});
        weights += 1;
      }
    }
    params['answerDTOS'] = answerDTOS;

    return params;
  }

  static Future<List<ContentModel>> editQuestionConfig(var data) async {
    List<ContentModel> result = [];
    Map type = data['type'];
    List<ContentIndustryModel> typeList = [];
    if (type != null) {
      type.forEach((key, value) {
        typeList.add(
            ContentIndustryModel(id: value[''], typeName: value['type_name']));
      });
    } else {
      typeList.add(ContentIndustryModel(typeName: '无意图'));
    }
    List<ContentModel> _questionAndClassifyDataList = [
      ContentModel(
        title: '问题分类：',
        content: '无意图',
        typeList: typeList,
      ),
      ContentModel(title: '问题：', content: data['question']),
    ];
    List<ContentModel> _answerList = [];
    String question = data['question'];
    List answers = data['answers'];
    result.addAll(_questionAndClassifyDataList);
    result.addAll(_answerList);
    result.add(ContentModel(title: '添加答案'));
    result.add(ContentModel(title: '附件标题'));
    result.add(ContentModel(title: '附件'));
    result.add(ContentModel(title: '提示'));
    result.add(ContentModel(title: '提交'));
    for (var item in answers) {
      String answer = item['answer'];
      String imgUrl = item['imgUrl'];
      String audioUrl = item['audioUrl'];
      String videoUrl = item['videoUrl'];
      String hyperlinkUrl = item['hyperlinkUrl'];
      Map applicationVo = item['applicationVo'];

      if (answer != null && answer?.length > 0) {
        result.insert(
          2 + _answerList?.length ?? 0,
          ContentModel(title: '答案：', content: answer),
        );
        _answerList.add(ContentModel(content: answer, title: '答案：'));
      }

      if (imgUrl != null && imgUrl?.length > 0) {
        result.insert(
          result.length - 3,
          ContentModel(
            title: '图片',
            content: imgUrl,
          ),
        );
      }
      if (videoUrl != null && videoUrl?.length > 0) {
        VideoPlayerController _videoController =
            await VideoPlayerController.network(videoUrl);
        _videoController.setLooping(true);
        Future _initializeVideoPlayerFuture = _videoController.initialize();
        result.insert(
          result.length - 3,
          ContentModel(
            title: '视频',
            content: videoUrl,
            videoController: _videoController,
            initializeVideoPlayerFuture: _initializeVideoPlayerFuture,
          ),
        );
      }
      if (audioUrl != null && audioUrl?.length > 0) {
        final player = AudioPlayer();
        var duration = await player.setUrl(audioUrl);
        result.insert(
          result.length - 3,
          ContentModel(
            title: '一段录音',
            content: audioUrl,
            voiceTime: double.parse('${duration.inSeconds}'),
          ),
        );
      }
      if (hyperlinkUrl != null && hyperlinkUrl?.length > 0) {
        result.insert(
          result.length - 3,
          ContentModel(
            title: '超链接',
            content: hyperlinkUrl,
          ),
        );
      }
      if (applicationVo != null) {
        result.insert(
          result.length - 3,
          ContentModel(
            title: '电话应用',
            content: applicationVo['mobile'],
          ),
        );
      }
    }

    return result;
  }

  static Future<List<ContentModel>> editAnswerList(var data) async {
    List<ContentModel> result = [];
    List answers = data['answers'];
    for (var item in answers) {
      String answer = item['answer'];
      if (answer != null && answer?.length > 0) {
        result.add(ContentModel(content: answer, title: '答案：'));
      }
    }
    return result;
  }

  //更新附件数量
  static Future<List<ContentModel>> updateNums(
      List<ContentModel> dataList) async {
    List<ContentModel> result = dataList;
    ContentModel model = ContentModel(
      title: '附件',
      voiceNum: PublicUnitls.calculateInt(dataList, '一段录音'),
      videoNum: PublicUnitls.calculateInt(dataList, '视频'),
      imageNum: PublicUnitls.calculateInt(dataList, '图片'),
      applyNum: PublicUnitls.calculateInt(dataList, '电话应用'),
      linkNum: PublicUnitls.calculateInt(dataList, '超链接'),
    );

    for (var i = 0; i < dataList.length; i++) {
      ContentModel item = dataList[i];
      if (item.title == '附件') {
        result[i] = model;
      }
    }

    return result;
  }

//####################首页问答的业务处理######################

  //配置首页对话Model
  static Future<List<ConverseModel>> homeConverseModel(var data,
      {String headImage, int robotId}) async {
    String answerType = data['data']['answerType'];
    if (answerType == 'B') {
      //正常回答
      return await PublicUnitls.normalConverseModel(data['data'],
          headImage: headImage, robotId: robotId);
    }
    if (answerType == 'InvalidAnswer') {
      //万能答案
      return PublicUnitls.omnipotentConverseModel(data['data'],
          headImage: headImage, robotId: robotId);
    }
    if (answerType == 'application') {
      //应用类型

    }
    return null;
  }

  //正常回答
  static Future<List<ConverseModel>> normalConverseModel(var data,
      {String headImage, int robotId}) async {
    List<ConverseModel> result = [];
    //固定来自他人
    int from = 1;
    List answers = data['answers'];
    int id = int.parse(data['id']);
    for (var item in answers) {
      String answer = item['answer'];
      String imgUrl = item['imgUrl'];
      String audioUrl = item['audioUrl'];
      String videoUrl = item['videoUrl'];
      String hyperlinkUrl = item['hyperlinkUrl'];
      Map applicationVo = item['applicationVo'];

      if (answer != null && answer?.length > 0) {
        //文本回答
        result.add(ConverseModel(
            type: 0,
            content: answer,
            id: id,
            robotId: robotId,
            isCanEdit: true,
            userModel: UserModel(headImage: headImage)));
      }
      if (imgUrl != null && imgUrl?.length > 0) {
        //图片
        result.add(ConverseModel(
            type: 1,
            content: imgUrl,
            id: id,
            robotId: robotId,
            isCanEdit: true,
            userModel: UserModel(headImage: headImage)));
      }
      if (audioUrl != null && audioUrl?.length > 0) {
        final player = AudioPlayer();
        var duration = await player.setUrl(audioUrl);
        //声音
        result.add(ConverseModel(
            type: 2,
            content: audioUrl,
            id: id,
            robotId: robotId,
            isCanEdit: true,
            voiceTime: duration.inSeconds,
            userModel: UserModel(headImage: headImage)));
      }
      if (videoUrl != null && videoUrl?.length > 0) {
        VideoPlayerController _videoController =
            await VideoPlayerController.network(videoUrl);
        _videoController.setLooping(true);
        Future _initializeVideoPlayerFuture = _videoController.initialize();
        //视频
        result.add(ConverseModel(
            type: 3,
            content: videoUrl,
            id: id,
            robotId: robotId,
            isCanEdit: true,
            videoController: _videoController,
            initializeVideoPlayerFuture: _initializeVideoPlayerFuture,
            userModel: UserModel(headImage: headImage)));
      }
      if (hyperlinkUrl != null && hyperlinkUrl?.length > 0) {
        //超链接
        result.add(ConverseModel(
            type: 5,
            content: hyperlinkUrl,
            id: id,
            robotId: robotId,
            isCanEdit: true,
            userModel: UserModel(headImage: headImage)));
      }
      if (applicationVo != null && !applicationVo?.isEmpty) {
        //应用
        result.add(ConverseModel(
            type: 6,
            applicationVo: applicationVo,
            id: id,
            robotId: robotId,
            userModel: UserModel(headImage: headImage)));
      }
    }

    return result;
  }

  //万能回答
  static List<ConverseModel> omnipotentConverseModel(var data,
      {String headImage, int robotId}) {
    List<ConverseModel> result = [];
    //固定来自他人
    int from = 1;
    List answers = data['answers'];
    int id = data['id'];
    if (answers == null) {
      result.add(ConverseModel(
          type: 0,
          content: '未匹配到答案',
          id: id,
          robotId: robotId,
          userModel: UserModel(headImage: headImage)));
      return result;
    }

    for (var item in answers) {
      String answer = item['context'];
      //文本回答
      result.add(ConverseModel(
          type: 0,
          content: answer,
          id: id,
          robotId: robotId,
          userModel: UserModel(headImage: headImage)));
    }
    return result;
  }

//选中的 是否有重复分类
  static Future<bool> duplicateClass(
      List<ContentIndustryModel> typeList, ContentIndustryModel model) async {
    //为空
    if (typeList == null || typeList.length < 1) {
      return false;
    }
    //有意图分类，其他分类全部不添加
    ContentIndustryModel temModel;
    List result = [];
    for (var item in typeList) {
      if (item.id == model.id) {
        result.add(item.id);
      }
      if (item.typeName == '无意图') {
        temModel = item;
      }
    }

    if (typeList.length > 0 && model.typeName == '无意图') {
      ToastView(
        title: '已选其他分类，不可选无意图',
      ).showMessage();
      return true;
    }

    if (temModel != null) {
      ToastView(
        title: '已选无意图',
      ).showMessage();
      return true;
    }

    if (result.length < 1) {
      return false;
    }
    ToastView(
      title: '重复选择分类',
    ).showMessage();
    return true;
  }
}
