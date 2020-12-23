import 'package:flutter/material.dart';

class CommonWidgets {

  ///标题栏
  static Widget titleBar(BuildContext context, String title, //标题文字
      {bool showIcon = true, //是否显示返回按钮
      String iconAssets = '', //返回按钮图片。默认为向左箭头
      String moreAssets = '', //右侧菜单按钮图片。默认不显示
      bool showShadow = true, //标题栏底部是否显示阴影
      Color color,
      Brightness brightness = Brightness.light,
      Function backAction,
      Widget action}) {//右侧菜单按钮组件。默认没有菜单，与moreAssets冲突，当两者都存在时，使用该属性。
    Color appBarTextColor() {
      return Color.fromARGB(255, 74, 74, 74);
    }

    Color _shadowColor = showShadow
        ? Color.fromARGB(50, 253, 253, 253)
        : Color.fromARGB(0, 0, 0, 0);

    Widget _reBackImg(String icon) {
      return InkWell(
        onTap: () {

          if (backAction != null) {
            backAction();
            return;
          }
          Navigator.pop(context);
        },
        child: Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          child: Image.asset(
            icon,
            fit: BoxFit.cover,
            width: 15,
            height: 15,
          ),
        ),
      );
    }

    Widget _reSizeImg(String icon) {
      return Container(
        width: 35,
        height: 20,
        alignment: Alignment.centerLeft,
        child: Image.asset(
          icon,
          fit: BoxFit.cover,
          width: 20,
          height: 20,
        ),
      );
    }

    Widget _back() {
      Widget icon;
      if (showIcon) {
        if (iconAssets.isEmpty) {
          icon = _reBackImg('assets/images/icon_back_image.png');
        } else {
          icon = _reBackImg(iconAssets);
        }
      } else {
        icon = Text('');
      }
      return icon;
    }

    List<Widget> actionMenu = action == null
        ? (moreAssets.isEmpty ? [] : [_reSizeImg(moreAssets)])
        : [action];

    return AppBar(
      leading: _back(),
      backgroundColor: color,
      centerTitle: true,
      brightness: brightness,
      title: Text(title,
          style: TextStyle(
            fontSize: 16,
            color: appBarTextColor(),
          )),
      // toolbarHeight: 45,
      shadowColor: _shadowColor,
      actions: actionMenu,
    );
  }
}
