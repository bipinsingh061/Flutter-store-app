import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPage extends StatefulWidget {
  final String url;
  FullPage({this.url});
  @override
  _FullPageState createState() => _FullPageState(this.url);
}

class _FullPageState extends State<FullPage> {
  String url;
  _FullPageState(this.url) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height
      child : PhotoView(imageProvider: CachedNetworkImageProvider(url))
      // width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   image: DecorationImage(image: NetworkImage(url), fit: BoxFit.fitWidth  ),
      // ),
    );
  }
}
