import 'package:flutter/material.dart';

enum InputType {
  TextType, //文本输入
  VoiceType, //语音输入
  CommonType, //常用语输入
  AddType,//添加输入
}

class BottomInputBar extends StatefulWidget {
  InputBarDelegate delegate;
  BottomInputBar({Key key, this.delegate}) : super(key: key);
  @override
  _BottomInputBarState createState() => _BottomInputBarState();
}

class _BottomInputBarState extends State<BottomInputBar> {
  InputType _inputType = InputType.VoiceType;
  InputType _changeButtonType = InputType.VoiceType;
  TextEditingController _controller = TextEditingController();
  InputBarDelegate _delegate;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _delegate = widget.delegate;
    _focusNode.addListener(() { 
      if (_focusNode.hasFocus) {
        setState(() {
          _inputType = InputType.TextType;
        });
      }
    });
  }

  //#########actions#########
  void _changeClick() {
    if (_changeButtonType == InputType.VoiceType) {
      _changeButtonType = InputType.TextType;
    } else if (_changeButtonType == InputType.TextType) {
      _changeButtonType = InputType.VoiceType;
    }
    _inputType = _changeButtonType;
    setState(() {});
  }

  //#########widgets#########
  Widget _changeButtonWidget() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 7),
        child: _leftImageWidget(),
      ),
      onTap: _changeClick,
    );
  }

  Widget _leftImageWidget() {
    if (_changeButtonType == InputType.TextType) {
      return Image.asset(
        'assets/images/btn_keyboard.png',
        width: 28,
        height: 28,
      );
    } else {
      return Image.asset(
        'assets/images/icon_voice_input.png',
        width: 28,
        height: 28,
      );
    }
  }

//文字和语音输入
  Widget _centerInputWidget() {
    return Expanded(
        child: Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: new Border.all(color: Color(0xFFE5E5E5), width: 1),
      ),
      child: _centerContentWidget(),
    ));
  }

  Widget _centerContentWidget() {
    if (_changeButtonType == InputType.VoiceType) {
      return GestureDetector(
        child: Center(
          child: Text(
            '按住 说话',
            style: TextStyle(color: Color(0xFF3B3B3B)),
          ),
        ),
        onLongPressUp: () {
          print('手指离开');
        },
        onLongPress: () {
          print('手指按上');
        },
        onTap: () {
          if (widget.delegate != null) {
            widget.delegate.speechClick();
          }
        },
      );
    } else {
      return TextField(
        focusNode: _focusNode,
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 18, bottom: 8),
          hintText: '请输入问题',
          hintStyle: TextStyle(fontSize: 15),
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          _controller.clear();
          if (_delegate != null && value.length > 0) {
            _delegate.submmitClick(value);
          }
        },
        
      );
    }
  }

//常用语
  Widget _commonWordButton() {
    return GestureDetector(
      child: Container(
        width: 69,
        height: 36,
        margin: EdgeInsets.only(left: 9, right: 8),
        decoration: BoxDecoration(
            color: Color(0xFF849FDB), borderRadius: BorderRadius.circular(6)),
        child: Center(
          child: Text(
            '常用语',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _inputType = InputType.CommonType;
        });
      },
    );
  }

//添加按钮
  Widget _addButton() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 18),
        child: Image.asset(
          'assets/images/icon_add_to.png',
          width: 28,
          height: 28,
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _inputType = InputType.AddType;
        });
      },
    );
  }

//输入框
  Widget _inputWidget() {
    return Container(
      height: 62,
      color: Color(0xFFEFEFEF),
      child: Row(
        children: [
          //左侧更换输入方式按钮
          _changeButtonWidget(),
          //中间输入
          _centerInputWidget(),
          //常用语
          _commonWordButton(),
          //添加按钮
          _addButton(),
        ],
      ),
    );
  }
//常用语
Widget _commonWordWidget() {
  return Container(
    height: 220,
    child: Center(child: Text('常用语'),),
  );
}


//定位/图片
Widget _addWidget() {
  return Container(
    height: 220,
    child: Center(child: Text('添加其他消息'),),
  );
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _inputWidget(),
        if(_inputType == InputType.CommonType)_commonWordWidget(),
        if(_inputType == InputType.AddType)_addWidget(),

      ],
    );
  }
}

abstract class InputBarDelegate {
  void submmitClick(String value); //发送输入框消息
  void speechClick(); //弹出语音输入页面
}
