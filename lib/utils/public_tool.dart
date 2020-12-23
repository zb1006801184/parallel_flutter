import 'package:editor_2020_9/pages/content_library/_photo_gallery_page.dart';
import 'package:editor_2020_9/pages/login/model/login_info_model.dart';
import 'package:editor_2020_9/pages/login/model/user_info_model.dart';
import 'package:editor_2020_9/utils/data_name_unitls.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:editor_2020_9/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:sk_alert_dialog/sk_alert_dialog.dart';

class PublicTool {
  //图片浏览器
  static imageBrowser(String imageUrl, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SeePhotoPage(
              imageUrl: imageUrl,
            )));
  }

  //清除本地状态
  static Future<void> removeInfo() {
    SpUtil.remove(DataName.TOKENINFO);
    SpUtil.remove(DataName.LOGINSTATE);
    SpUtil.remove(DataName.PERSONINFO);
    SpUtil.remove(DataName.USERINFO);
    SpUtil.remove(DataName.USERROBOTID);
    Global.userInfoModel = null;
    Global.tokenModel = null;
    Global.loginState = false;
  }

//保存登录信息
  static Future<void> savaUserInfo(
      {LoginInfoModel infoModel, String mobile, UserInfoModel data}) {
    SpUtil.setString(DataName.USERMOBILE, mobile);
    SpUtil.setBool(DataName.LOGINSTATE, true);
    SpUtil.setString(DataName.TOKENINFO, infoModel.accessToken);
    Global.tokenModel = infoModel;
    Global.userInfoModel = data;
    Global.loginState = true;
  }

//提示框
  static showMessageBox(BuildContext context,
      {String title = '提示', String content, Function onOkBtnTap}) {
    SKAlertDialog.show(
        context: context,
        showCancelBtn: false,
        type: SKAlertType.buttons,
        title: title,
        message: content,
        onOkBtnTap: onOkBtnTap,
        onCancelBtnTap: (e){},
        okBtnText: '确定',
        cancelBtnText: '取消');
  }
}
