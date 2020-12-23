import 'package:editor_2020_9/widgets/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  Map arguments;
  WebViewWidget({Key key, this.arguments}) : super(key: key);
  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  String _url = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _url = widget.arguments['url'];
    if (!_url.contains('http')) {
      _url = 'http://' + _url;
    }
    EasyLoading.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.titleBar(context, ''),
      body: WebView(
        initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) {
          EasyLoading.dismiss();
        },
      ),
    );
  }
}
