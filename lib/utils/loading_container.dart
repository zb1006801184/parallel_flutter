import 'package:flutter/material.dart';

//加载进度条组件
class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  LoadingContainer({
    this.child,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        isLoading
            ? Container(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Expanded(
                    child: Container(
                      color: Colors.black87,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            strokeWidth: 4,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "加载中",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
