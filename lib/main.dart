import 'package:editor_2020_9/app.dart';
import 'package:editor_2020_9/state/provider_store.dart';
import 'package:editor_2020_9/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils/platform_unitls.dart';
import 'utils/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  Global.init().then((value) {
      runApp(Store.init(child: MyApp()));
  });
  if (PlatformUtils.isAndroid) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarIconBrightness: Brightness.light
        );

    SystemChrome.setSystemUIOverlayStyle(style);
  }
  //自定义报错widget
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails){
        // print(flutterErrorDetails.toString());
        return Center(
          child: Text("出现了一点小小的问题~"),
          );
    };
}
