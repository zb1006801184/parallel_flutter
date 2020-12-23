import 'package:editor_2020_9/pages/converse_voice/converse_voice.dart';
import 'package:editor_2020_9/pages/home/HomePage.dart';
import 'package:editor_2020_9/pages/login/login_code.dart';
import 'package:editor_2020_9/pages/tabPage/home/home_robot_page.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/CreateModelHome.dart';
import 'package:editor_2020_9/pages/tabPage/wo/createModel/SelectIndustry.dart';
import 'package:editor_2020_9/pages/tabPage/xiaobian/createRobot/CreateRobot.dart';
import 'package:editor_2020_9/utils/data_name_unitls.dart';
import 'package:editor_2020_9/utils/sp_util.dart';
import 'package:editor_2020_9/widgets/web_view_widget.dart';
import 'package:flutter/material.dart';
import '../pages/tabPage/add/add_content_page.dart';
import '../pages/tabPage/add/classify_page.dart';

final routes = {
// '/': (context) => HomePage(),
  '/': (context) =>
      SpUtil.getBool(DataName.LOGINSTATE) ? HomePage() : LoginCodePage(),
  '/LoginCodePage': (context) => LoginCodePage(),

  '/robot_createMyRobot': (context, {arguments}) => CreateRobotPage(),
  '/robot_createModel': (context, {arguments}) => CreateModelHome(),
  '/select_industry': (context, {arguments}) => SelectIndustryPage(),
  '/AddContentPage': (context, {arguments}) => AddContentPage(
        arguments: arguments,
      ),
  '/ClassifyPage': (context, {arguments}) => ClassifyPage(
        arguments: arguments,
      ),
  '/WebViewWidget': (context, {arguments}) => WebViewWidget(
        arguments: arguments,
      ),
  '/HomeRobotPage': (context, {arguments}) => HomeRobotPage(
        arguments: arguments,
      ),
  '/ConverseVoicePage': (context, {arguments}) => ConverseVoicePage(),
};

var onGenerateRoute = (RouteSettings settings) {
  // ignore: top_level_function_literal_block
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
