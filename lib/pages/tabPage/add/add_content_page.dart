import 'package:dio/dio.dart';
import 'package:editor_2020_9/model/content_model.dart';
import 'package:editor_2020_9/network/ApiService.dart';
import 'package:editor_2020_9/network/ApiUrl.dart';
import 'package:editor_2020_9/pages/content_library/model/contenr_industry_model.dart';
import 'package:editor_2020_9/pages/tabPage/add/items/add_content_item.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/public_unitls.dart';
import 'package:editor_2020_9/utils/toast_view.dart';
import 'package:editor_2020_9/widgets/edit_detai_widget.dart';
import 'package:editor_2020_9/widgets/recoder_voice_widget.dart';
import 'package:editor_2020_9/widgets/sample_select.dart';
import 'package:editor_2020_9/widgets/speech_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:video_player/video_player.dart';
import '../../../widgets/CommonWidgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

class AddContentPage extends StatefulWidget {
  Map arguments;

  AddContentPage({Key key, this.arguments}) : super(key: key);

  @override
  _AddContentPageState createState() => _AddContentPageState();
}

class _AddContentPageState extends State<AddContentPage>
    implements AddContentItemDelegate {
  ScrollController controller = ScrollController();
  List<ContentModel> _dataList = [];

  List<ContentModel> _questionAndClassifyDataList;

  //答案列表
  List<ContentModel> _answerList = [
    ContentModel(title: '答案：'),
  ];

  //附件选择
  ContentModel _attachmentModel = ContentModel(title: '附件');

  //七牛token
  String token = '';

  int _type; // 默认0  0添加  1编辑
  int _id; //添加不用，编辑的时候必填，问答id
  int _robotId; //机器人id
  String _typeName; //默认分类名称
  int _parentId; //分类id

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rquest();
    if (widget.arguments != null) {
      _id = widget.arguments['id'] ?? 0;
      _type = widget.arguments['type'];
      _robotId = widget.arguments['robotId'];
      _typeName = widget.arguments['typeName'];
      _parentId = widget.arguments['parentId'];
      if (_type == 0) {
        _configViewsWithData();
      } else {
        _questionDetailRequest();
      }
    } else {
      _configViewsWithData();
    }
  }

  //###编辑
  void _questionDetailRequest() async {
    var data =
        await ApiService.getRobotDetailRequest(id: _id, robotId: _robotId);
    _dataList = await PublicUnitls.editQuestionConfig(data['data']);
    _answerList = await PublicUnitls.editAnswerList(data['data']);
    _updateUI();
  }

  //###添加
  void _rquest() async {
    ApiService.getQiniuTokenRequest().then((value) {
      token = value;
    });
  }

  void _configViewsWithData() {
    _questionAndClassifyDataList = [
      ContentModel(
        title: '问题分类：',
        content: '无意图',
        robotId: Global.userInfoModel.selectedRobotId,
        typeList: [ContentIndustryModel(typeName: '无意图', parentId: 0)],
      ),
      ContentModel(title: '问题：'),
    ];
    _dataList.addAll(_questionAndClassifyDataList);
    _dataList.addAll(_answerList);
    _dataList.add(ContentModel(title: '添加答案'));
    _dataList.add(ContentModel(title: '附件标题'));
    _dataList.add(_attachmentModel);
    _dataList.add(ContentModel(title: '提示'));
    _dataList.add(ContentModel(title: '提交'));
    //有意图
    if (_typeName != null) {
      _dataList[0] = ContentModel(
        title: '问题分类：',
        content: '无意图',
        typeList: [ContentIndustryModel(typeName: _typeName, id: _parentId)],
      );
    }
  }

//更新页面
  void _updateUI() async {
    await PublicUnitls.updateNums(_dataList);
    setState(() {});
  }

//#########################actions######################
  //添加答案
  void _didTapAddMoreAnswerItemClick() {
    if (_answerList.length >= 9) {
      ToastView(
        title: '答案最多只能九条',
      ).showMessage();
      return;
    }

    _dataList.insert(2 + _answerList?.length ?? 0, ContentModel(title: '答案：'));
    _answerList.add(ContentModel(title: '答案：'));
    _isShowAddAnswerAction();
    setState(() {});
  }

//答案如果满九条就隐藏按钮，不足则显示

  void _isShowAddAnswerAction() {
    if (_answerList.length >= 9) {
      _dataList[2 + _answerList.length] =
          ContentModel(title: '添加答案', isShowAddAnswer: false);
    } else {
      _dataList[2 + _answerList.length] =
          ContentModel(title: '添加答案', isShowAddAnswer: true);
    }
  }

  //点击超链接
  void _linkClick(ContentModel model) {
    Navigator.of(context)
        .pushNamed('/WebViewWidget', arguments: {'url': model.content ?? ''});
  }

  //删除item
  void _deleteItem(int index) {
    _dataList.removeAt(index);
    if (_answerList.length + 2 >= index + 1) {
      _answerList.removeAt(index - 2);
    }
    _isShowAddAnswerAction();
    _updateUI();
  }

  //输入框正在输入
  _textFieldChange(
      ContentModel model, int index, TextEditingController controller) {
    model.content = controller.text;
    _dataList[index] = model;
  }

  //语音转文字
  _speechToText(ContentModel model, int index) {
    String content = model.content ?? '';
    SpeechWidget.showSpeechWidget(context, (String result, String filePath) {
      model.content = content + result;
      _dataList[index] = model;
      setState(() {});
    });
  }

  //立即发布 / 保存草稿
  void _submitClick(String title) async {
    Map params = await PublicUnitls.submitParams(_dataList,
        title: title,
        robotId: _robotId ?? Global.userInfoModel.selectedRobotId);
    if (widget.arguments != null && _type == 1) {
      params['id'] = _id;
      ApiService.editRobotContentRequest(params).then((value) {
        if (value != null) {
          Navigator.of(context).pop();
        }
      });
    } else {
      // params['robotId'] = Global.userInfoModel.selectedRobotId;
      ApiService.addRobotContentRequest(params).then((value) {
        if (value != null) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  //分类的添加 删除
  void _classifyClick(ContentModel model) {}

  //添加附件
  void _addAttachmentAction(String title) async {
    if (title == '图片视频') {
      // title = '视频';
    }
    if (title == '万能应用') {
      title = '电话应用';
    }

    if (PublicUnitls.calculateInt(_dataList, title) >= 9) {
      ToastView(
        title: '${title}超过九条',
      ).showMessage();
      return;
    }

    if (title == '一段录音') {
      RecoderVoiceWidget.showRecoderVoiceWidget(context, (e, time) async {
        EasyLoading.show();
        final syStorage = new SyFlutterQiniuStorage();
        String key = DateTime.now().millisecondsSinceEpoch.toString() +
            '.' +
            e.split('uploadImageRequest.').last;

        var result = await syStorage.upload(e, token, key);
        ToastView(
          title: '上传成功',
        ).showMessage();
        EasyLoading.dismiss();
        _dataList.insert(
          _dataList.length - 3,
          ContentModel(
              title: title,
              voiceNum: PublicUnitls.calculateInt(_dataList, title) + 1,
              content: '${ApiUrl.IMAGE_URL}/${key}',
              voiceTime: double.parse(time ?? 0.0)),
        );
        _updateUI();
      });
    }
    if (title == '图片视频') {
      _addVideoAndImage(title);
    }

    if (title == '电话应用') {
      EditDetailWidget.showEditeBox(context, (e) async {
        if (e != null && e?.length > 0) {
          _dataList.insert(
            _dataList.length - 3,
            ContentModel(
                title: title,
                content: e,
                applyNum: PublicUnitls.calculateInt(_dataList, title) + 1),
          );
          _updateUI();
        }
      }, title: '手机号');
    }

    if (title == '超链接') {
      EditDetailWidget.showEditeBox(context, (e) async {
        if (e != null && e?.length > 0) {
          _dataList.insert(
            _dataList.length - 3,
            ContentModel(
                title: title,
                content: e,
                linkNum: PublicUnitls.calculateInt(_dataList, title) + 1),
          );
          _updateUI();
        }
      }, title: title);
    }
  }

  //添加视频/图片
  void _addVideoAndImage(String title) async {
    var cameraStatus = await Permission.camera.status;
    var photosStatus = await Permission.photos.status;
    if (cameraStatus.isUndetermined || photosStatus.isUndetermined) {
      await Permission.camera.request();
      await Permission.photos.request();
    }
    List dataList = ['视频', '图片'];

    showSampleSelect(context, dataList: ['视频', '图片'],
        callBackHandler: (index) async {
      PickedFile data;
      if (index == 0) {
        data = await ImagePicker().getVideo(
            source: ImageSource.gallery,
            maxDuration: const Duration(seconds: 10));
      } else {
        data = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      String path = data?.path;
      if (path == null) return;
      EasyLoading.show();
      final syStorage = new SyFlutterQiniuStorage();

      String key = DateTime.now().millisecondsSinceEpoch.toString() +
          '.' +
          (index == 0 ? 'mp4' : data.path.split('.').last);

      var result = await syStorage.upload(data.path, token, key);
      EasyLoading.dismiss();

      if (index == 0) {
        //上传视频
        VideoPlayerController _videoController =
            await VideoPlayerController.network('${ApiUrl.IMAGE_URL}/${key}');
        _videoController.setLooping(true);
        Future _initializeVideoPlayerFuture = _videoController.initialize();
        _dataList.insert(
          _dataList.length - 3,
          ContentModel(
            title: '视频',
            content: '${ApiUrl.IMAGE_URL}/${key}',
            videoNum: PublicUnitls.calculateInt(_dataList, title) + 1,
            videoController: _videoController,
            videoTime: _videoController.value.duration.toString(),
            initializeVideoPlayerFuture: _initializeVideoPlayerFuture,
          ),
        );
        _updateUI();
      } else {
        _dataList.insert(
          _dataList.length - 3,
          ContentModel(
            title: '图片',
            imageNum: PublicUnitls.calculateInt(_dataList, title) + 1,
            content: '${ApiUrl.IMAGE_URL}/${key}',
          ),
        );
        _updateUI();
      }
    });
  }

  Widget separatorWidget(int index) {
    ContentModel model = _dataList[index];
    if (model.title.contains('问题') ||
        model.title == '添加答案' ||
        model.title == '附件') {
      return Container(
        height: 12,
        color: Color(0xFFF5F5F5),
      );
    }
    return Container();
  }

  Widget _getListWidget() {
    return new ListView.separated(
      controller: controller,
      itemBuilder: (BuildContext context, int index) {
        return Slidable(
          child: AddContentItem(
            this,
            model: _dataList[index],
          ),
          actionPane: SlidableScrollActionPane(),
          enabled: PublicUnitls.isCanDelete(_dataList, index),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              color: Color(0xFFFFFF6F6D),
              iconWidget: Text(
                "删除",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              closeOnTap: true,
              onTap: () {
                _deleteItem(index);
              },
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return separatorWidget(index);
      },
      itemCount: _dataList?.length ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    ListView list = _getListWidget();
    return Scaffold(
      appBar: CommonWidgets.titleBar(
          context, (_type != null && _type == 1) ? '编辑问答' : '添加问答'),
      body: GestureDetector(
        child: _getListWidget(),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );

    @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
    }
  }

  @override
  void didTapAddMoreAnswerItem() {
    _didTapAddMoreAnswerItemClick();
  }

  void submmitClick(String title) {
    _submitClick(title);
  }

  void attachmentClick(String title) {
    _addAttachmentAction(title);
  }

  void textFieldChange(
      ContentModel model, int index, TextEditingController controller) {
    _textFieldChange(model, index, controller);
  }

  void classifyClick(ContentModel model) {
    _classifyClick(model);
  }

  void speechToText(ContentModel model, int index) {
    _speechToText(model, index);
  }

  void linkClick(
    ContentModel model,
  ) {
    _linkClick(model);
  }
}
