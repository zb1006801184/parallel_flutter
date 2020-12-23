import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

///查看大图
class SeePhotoPage extends StatefulWidget {
  final String imageUrl;

  SeePhotoPage({
    Key key,
    this.imageUrl,
  }) : super(key: key);

  @override
  _SeePhotoPageState createState() => _SeePhotoPageState();
}

class _SeePhotoPageState extends State<SeePhotoPage> {
  String _imageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: PhotoView(
          imageProvider: NetworkImage(_imageUrl),
        ),
      ),
    );
  }
}
