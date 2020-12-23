import 'package:editor_2020_9/widgets/_search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SearchDemo extends StatefulWidget {
  @override
  _SearchDemoState createState() => _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {

  FocusNode _focusNode;
  TextEditingController _controller;
  String _searchText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new SearchAppBarWidget(
          focusNode: _focusNode,
          controller: _controller,
          elevation: 2.0,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(150),
          ],
          onEditingComplete: () {
            print('搜索框输入的内容是： ${_controller.text}');
            setState(() {
              _searchText = _controller.text;
            });

            _focusNode.unfocus();
          },
        ),


        body: Center(
          child: Text("搜索内容: $_searchText"),
        )
    );
  }
}