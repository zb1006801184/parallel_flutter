import 'package:flutter_easyloading/flutter_easyloading.dart';

class EasyLoadingUnitls {
  static configEasyLoading() {
    EasyLoading.instance
  // ..displayDuration = const Duration(milliseconds: 2000)
  // ..indicatorType = EasyLoadingIndicatorType.fadingCircle
  ..loadingStyle = EasyLoadingStyle.light //提示框背景样式
  // ..indicatorSize = 45.0 
  // ..radius = 10.0
  // ..progressColor = Colors.yellow
  // ..backgroundColor = Colors.green
  // ..indicatorColor = Colors.yellow
  // ..textColor = Colors.yellow
  // ..maskColor = Colors.blue.withOpacity(0.5)
  ..userInteractions = false;//加载时是否可点击
  // ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
  }


}