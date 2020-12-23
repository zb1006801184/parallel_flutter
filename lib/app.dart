import 'package:editor_2020_9/pages/home/HomePage.dart';
import 'package:editor_2020_9/pages/login/login_code.dart';
import 'package:editor_2020_9/state/provider_store.dart';
import 'package:editor_2020_9/state/them_model.dart';
import 'package:editor_2020_9/utils/Route.dart';
import 'package:editor_2020_9/utils/easyloading_unitls.dart';
import 'package:editor_2020_9/utils/them_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:developer' as developer;

import 'package:flutter_localizations/flutter_localizations.dart';

import 'utils/Route.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static BuildContext getContext() {
    return _MyAppState.getInstance();
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String pageName = "example.main";
  AppLifecycleState currentState = AppLifecycleState.resumed;
  DateTime notificationQuietEndTime;
  DateTime notificationQuietStartTime;
  static BuildContext appContext;

  static BuildContext getInstance() {
    return appContext;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoadingUnitls.configEasyLoading();
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: Locale('zh'),
      onGenerateRoute: onGenerateRoute,
      themeMode: Store.value<ThemModel>(context).getThemeModel()
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemUntil().darktData,
      theme: ThemUntil().linghtData,
      builder: EasyLoading.init(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    developer.log("--" + state.toString(), name: pageName);
    currentState = state;
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }
}
