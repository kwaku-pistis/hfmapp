import 'dart:io';

import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';

class SendMedia extends StatefulWidget {
  final String groupId;
  final String id;
  final String friendId;
  final File imageFile;
  SendMedia(
      {required this.imageFile,
      required this.groupId,
      required this.id,
      required this.friendId});
  @override
  State<StatefulWidget> createState() =>
      SendMediaState(imageFile, groupId, id, friendId);
}

class SendMediaState extends State<SendMedia> {
  final String groupId;
  final String id;
  final String friendId;
  final File imageFile;
  SendMediaState(this.imageFile, this.groupId, this.id, this.friendId);

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: Center(
        child: Image.file(imageFile),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: colortheme.accentColor,
          child: Icon(Icons.send),
          onPressed: () => Navigator.pop(context, [true])),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(
        'Send media',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
