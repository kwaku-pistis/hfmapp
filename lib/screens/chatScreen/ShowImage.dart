import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatefulWidget {
  final String imageUrl;
  final String tag;

  const ShowImage({Key? key, required this.imageUrl, required this.tag})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowImageState();
}

class ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('media'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
            tag: widget.tag,
            child: CachedNetworkImage(imageUrl: widget.imageUrl)),
      ),
    );
  }
}
