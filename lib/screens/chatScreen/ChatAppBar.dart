import 'dart:async';

import 'package:HFM/Consts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

///appBar
class ChatAppBar extends StatefulWidget {
  final String photoUri;
  final String displayName;
  final String id;
  final String about;
  ChatAppBar(
      {required this.photoUri,
      required this.displayName,
      required this.id,
      required this.about});
  @override
  State<StatefulWidget> createState() => ChatAppBarState(
      photoUri: photoUri, displayName: displayName, id: id, about: about);
}

class ChatAppBarState extends State<ChatAppBar> {
  final String photoUri;
  final String displayName;
  final String id;
  final String about;
  String userStatus = '';

  late StreamSubscription<Event> stateListener;

  ChatAppBarState(
      {required this.photoUri,
      required this.displayName,
      required this.id,
      required this.about});
  @override
  void initState() {
    super.initState();
    stateListener = FirebaseDatabase.instance
        .reference()
        .child('/status/$id')
        .onValue
        .listen((event) {
      setState(() {
        userStatus = event.snapshot.value['state'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          //user image
          Container(
            child: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(),
                ),
                imageUrl: photoUri,
                width: APP_BAR_IMAGE_WIDTH,
                height: APP_BAR_IMAGE_HEIGHT,
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(APP_BAR_IMAGE_RADIUS)),
              clipBehavior: Clip.antiAlias,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 8.0, left: 10),
                  child: Text(
                    displayName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(userStatus,
                    style: TextStyle(fontSize: 10.0, color: Colors.white))
              ],
            ),
          )
        ],
      ),
      onTap: () {},
    );
  }

  @override
  void dispose() {
    stateListener.cancel();
    super.dispose();
  }
}
