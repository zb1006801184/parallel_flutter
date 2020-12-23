import 'package:flutter/cupertino.dart';
import '../utils/sp_util.dart';
import '../utils/them_util.dart';

class ThemModel extends ChangeNotifier {
  bool getThemeModel() {
    bool state = SpUtil.getBool(ThemUntil.THEMSTATE);
    return state ?? false;
  }

  changetThemModel() {
    bool state = SpUtil.getBool(ThemUntil.THEMSTATE);
    SpUtil.setBool(ThemUntil.THEMSTATE, !state ?? true);
    notifyListeners();
  }
}
