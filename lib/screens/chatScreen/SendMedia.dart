import 'dart:io';

import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';

class SendMedia extends StatefulWidget {
  final String groupId;
  final String id;
  final String friendId;
  final File imageFile;

  const SendMedia(
      {Key? key,
      required this.imageFile,
      required this.groupId,
      required this.id,
      required this.friendId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SendMediaState();
}

class SendMediaState extends State<SendMedia> {
  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: Center(
        child: Image.file(widget.imageFile),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: colorTheme.primaryColorDark,
          child: const Icon(Icons.send),
          onPressed: () => Navigator.pop(context, [true])),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text(
        'Send media',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
